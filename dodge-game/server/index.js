import { createHmac, randomBytes, scrypt, timingSafeEqual } from "node:crypto";
import { promisify } from "node:util";
import express from "express";
import { MongoClient } from "mongodb";

const { MONGODB_URI, DB_NAME = "dodge", JWT_SECRET, PORT = 3000 } = process.env;

if (!MONGODB_URI || !JWT_SECRET) throw new Error("MONGODB_URI and JWT_SECRET are required");

const TOKEN_TTL = 30 * 24 * 60 * 60 * 1000;
const scryptAsync = promisify(scrypt);

const mac = (body) => createHmac("sha256", JWT_SECRET).update(body).digest("base64url");
const same = (a, b) => a.length === b.length && timingSafeEqual(Buffer.from(a), Buffer.from(b));
const sign = (username) => {
  const body = Buffer.from(JSON.stringify({ username, exp: Date.now() + TOKEN_TTL })).toString("base64url");
  return `${body}.${mac(body)}`;
};
const verify = (token = "") => {
  const [body = "", signature = ""] = token.split(".");
  if (!same(signature, mac(body))) return null;
  const { username, exp } = JSON.parse(Buffer.from(body, "base64url").toString());
  return exp > Date.now() ? username : null;
};
const hashPassword = async (password, salt = randomBytes(16).toString("hex")) =>
  `${salt}:${(await scryptAsync(password, salt, 64)).toString("hex")}`;
const checkPassword = async (password, stored) => same(await hashPassword(password, stored.split(":")[0]), stored);
const field = (req, key) => String(req.body?.[key] ?? "");
const publicUser = ({ name, username, bestScore, bestLevel, bestTime = 0, settings }) => ({ name, username, bestScore, bestLevel, bestTime, settings });
const session = (user) => ({ token: sign(user.username), user: publicUser(user) });
const fail = (res, status, error) => res.status(status).json({ error });

const client = await MongoClient.connect(MONGODB_URI);
const users = client.db(DB_NAME).collection("users");
await users.createIndex({ username: 1 }, { unique: true });
await users.createIndex({ bestTime: -1, bestScore: -1, _id: 1 });

const auth = async (req, res, next) => {
  const username = verify(req.get("authorization")?.replace("Bearer ", ""));
  const user = username && (await users.findOne({ username }));
  if (!user) return fail(res, 401, "Unauthorized");
  req.user = user;
  next();
};

const app = express();
app.use(express.json());

app.post("/api/register", async (req, res) => {
  const name = field(req, "name").trim();
  const username = field(req, "username").trim().toLowerCase();
  const password = field(req, "password");
  if (!name || name.length > 30) return fail(res, 400, "Name must be 1-30 characters");
  if (!/^[a-z0-9_]{3,20}$/.test(username)) return fail(res, 400, "Username must be 3-20 letters, numbers or _");
  if (password.length < 6 || password.length > 72) return fail(res, 400, "Password must be 6-72 characters");
  const user = { name, username, passwordHash: await hashPassword(password), bestScore: 0, bestLevel: 1, bestTime: 0, createdAt: new Date() };
  try {
    await users.insertOne(user);
  } catch (error) {
    if (error.code === 11000) return fail(res, 409, "Username already taken");
    throw error;
  }
  res.status(201).json(session(user));
});

app.post("/api/login", async (req, res) => {
  const user = await users.findOne({ username: field(req, "username").trim().toLowerCase() });
  if (!user || !(await checkPassword(field(req, "password"), user.passwordHash))) return fail(res, 401, "Invalid username or password");
  res.json(session(user));
});

app.get("/api/me", auth, (req, res) => res.json({ user: publicUser(req.user) }));

app.put("/api/score", auth, async (req, res) => {
  const score = Math.floor(Number(req.body?.score));
  const level = Math.floor(Number(req.body?.level));
  const time = Number(req.body?.time ?? 0);
  if (!Number.isFinite(score) || !Number.isFinite(level) || !Number.isFinite(time) || score < 0 || level < 1 || time < 0) return fail(res, 400, "Invalid score");
  const user = await users.findOneAndUpdate({ _id: req.user._id }, { $max: { bestScore: score, bestLevel: level, bestTime: time } }, { returnDocument: "after" });
  res.json({ user: publicUser(user) });
});

app.put("/api/settings", auth, async (req, res) => {
  const { music, sfx, music_muted, sfx_muted, show_fps, theme = "classic" } = req.body ?? {};
  const volume = (value) => Number.isFinite(value) && value >= 0 && value <= 1;
  if (!volume(music) || !volume(sfx) || ![music_muted, sfx_muted, show_fps].every((value) => typeof value === "boolean") || typeof theme !== "string" || !/^[a-z]{1,20}$/.test(theme)) return fail(res, 400, "Invalid settings");
  const settings = { music, sfx, music_muted, sfx_muted, show_fps, theme };
  await users.updateOne({ _id: req.user._id }, { $set: { settings } });
  res.json({ settings });
});

app.get("/api/leaderboard", async (req, res) => {
  const me = verify(req.get("authorization")?.replace("Bearer ", ""));
  const skip = Math.max(0, Math.floor(Number(req.query.skip)) || 0);
  const limit = Math.min(50, Math.max(1, Math.floor(Number(req.query.limit)) || 50));
  const players = await users.find({ bestTime: { $gt: 0 } }).sort({ bestTime: -1, bestScore: -1, _id: 1 }).skip(skip).limit(limit).toArray();
  res.json({ entries: players.map(({ name, username, bestScore, bestTime }) => ({ name, bestScore, bestTime, me: username === me })) });
});

app.use((error, _req, res, _next) => fail(res, error.status ?? 500, error.expose ? error.message : "Server error"));

app.listen(PORT);