extends RefCounted

const CAR_COLORS: Array[Color] = [Color("#ef4444"), Color("#f97316"), Color("#a855f7"), Color("#22c55e"), Color("#e5e7eb")]
const EGG_COLORS: Array[Color] = [Color("#fdf6e3"), Color("#e8c39e"), Color("#cfe8e0")]


static func noise(index: int, salt: float) -> float:
	return fposmod(sin(index * 12.9898 + salt * 78.233) * 43758.5453, 1.0)


static func box(canvas: CanvasItem, at: Vector2, half: Vector2, color: Color) -> void:
	canvas.draw_rect(Rect2(at - half, half * 2.0), color)


static func shape(canvas: CanvasItem, at: Vector2, points: Array, color: Color) -> void:
	canvas.draw_colored_polygon(PackedVector2Array(points.map(func(point: Vector2) -> Vector2: return at + point)), color)


static func ring(at: Vector2, radius: Vector2, angle: float = 0.0, count: int = 20) -> PackedVector2Array:
	var points := PackedVector2Array()
	for i in count:
		points.append(at + (Vector2.from_angle(TAU * i / count) * radius).rotated(angle))
	return points


static func oval(canvas: CanvasItem, at: Vector2, radius: Vector2, color: Color, angle: float = 0.0) -> void:
	canvas.draw_colored_polygon(ring(at, radius, angle), color)


static func outline(canvas: CanvasItem, points: PackedVector2Array, color: Color, width: float) -> void:
	points.append(points[0])
	canvas.draw_polyline(points, color, width)


static func glow(canvas: CanvasItem, at: Vector2, radius: float, color: Color) -> void:
	for i in 3:
		canvas.draw_circle(at, radius * (1.0 + i * 0.3), Color(color, 0.14 - i * 0.04))


static func gradient(canvas: CanvasItem, rect: Rect2, top: Color, bottom: Color) -> void:
	canvas.draw_polygon(PackedVector2Array([rect.position, Vector2(rect.end.x, rect.position.y), rect.end, Vector2(rect.position.x, rect.end.y)]), PackedColorArray([top, top, bottom, bottom]))


static func ridge(canvas: CanvasItem, size: Vector2, base: float, height: float, wave: float, color: Color) -> void:
	var points := PackedVector2Array()
	for i in 25:
		points.append(Vector2(size.x * i / 24.0, base - height * absf(sin(i * wave))))
	points.append(size)
	points.append(Vector2(0.0, size.y))
	canvas.draw_colored_polygon(points, color)


static func drift(canvas: CanvasItem, size: Vector2, time: float, count: int, speed: float, radius: float, color: Color) -> void:
	for i in count:
		var rate: float = speed * (0.4 + noise(i, 3.0))
		var at := Vector2(noise(i, 1.0) * size.x + sin(time + i) * 8.0, fposmod(noise(i, 2.0) * size.y + time * rate, size.y))
		canvas.draw_circle(at, radius * (0.5 + noise(i, 4.0)), Color(color, color.a * (0.6 + 0.4 * sin(time * 2.0 + i))))


static func background(canvas: CanvasItem, look: Dictionary, size: Vector2, time: float) -> void:
	gradient(canvas, Rect2(Vector2.ZERO, size), look.top, look.bottom)
	match look.id:
		"classic":
			_classic(canvas, look, size, time)
		"cosmic":
			_cosmic(canvas, look, size, time)
		"highway":
			_highway(canvas, size, time)
		"farm":
			_farm(canvas, size, time)
		"ocean":
			_ocean(canvas, size, time)
		"synthwave":
			_synthwave(canvas, look, size, time)
		"winter":
			_winter(canvas, size, time)
		"volcano":
			_volcano(canvas, size, time)


static func _classic(canvas: CanvasItem, look: Dictionary, size: Vector2, time: float) -> void:
	for x in range(0, int(size.x) + 1, 90):
		canvas.draw_line(Vector2(x, 0.0), Vector2(x, size.y), Color(look.accent, 0.14), 2.0)
	var y: float = fposmod(time * 60.0, 90.0)
	while y < size.y:
		canvas.draw_line(Vector2(0.0, y), Vector2(size.x, y), Color(look.accent, 0.14), 2.0)
		y += 90.0
	for i in 16:
		var half: float = 8.0 + noise(i, 4.0) * 22.0
		var at := Vector2(noise(i, 1.0) * size.x, fposmod(noise(i, 2.0) * size.y + time * (20.0 + noise(i, 3.0) * 50.0), size.y + 60.0) - 30.0)
		canvas.draw_rect(Rect2(at - Vector2(half, half), Vector2(half, half) * 2.0), Color(look.accent if i % 2 == 0 else look.glow, 0.18), false, 2.0)


static func _cosmic(canvas: CanvasItem, look: Dictionary, size: Vector2, time: float) -> void:
	glow(canvas, Vector2(size.x * 0.2, size.y * 0.35), size.x * 0.28, look.accent)
	glow(canvas, Vector2(size.x * 0.75, size.y * 0.7), size.x * 0.22, look.glow)
	drift(canvas, size, time, 70, 20.0, 1.5, Color.WHITE)
	drift(canvas, size, time, 25, 70.0, 2.5, Color("#c4b5fd"))
	var planet := Vector2(size.x * 0.8, size.y * 0.16)
	canvas.draw_circle(planet, size.x * 0.09, Color("#6d4bd8"))
	canvas.draw_circle(planet + Vector2(-10.0, -10.0), size.x * 0.055, Color("#8b6cff"))
	outline(canvas, ring(planet, Vector2(size.x * 0.15, size.x * 0.03), -0.35, 40), Color(look.glow, 0.6), 3.0)


static func _highway(canvas: CanvasItem, size: Vector2, time: float) -> void:
	for side in [0.0, size.x - 24.0]:
		canvas.draw_rect(Rect2(side, 0.0, 24.0, size.y), Color("#14532d"))
	for x in [27.0, size.x - 27.0]:
		canvas.draw_line(Vector2(x, 0.0), Vector2(x, size.y), Color("#f5b800"), 4.0)
	var y: float = fposmod(time * 340.0, 130.0) - 130.0
	while y < size.y:
		for lane in range(1, 4):
			canvas.draw_rect(Rect2(size.x * lane / 4.0 - 3.0, y, 6.0, 65.0), Color(1, 1, 1, 0.35))
		for x in [12.0, size.x - 12.0]:
			canvas.draw_circle(Vector2(x, y + 100.0), 10.0, Color("#22c55e"))
		y += 130.0


static func _farm(canvas: CanvasItem, size: Vector2, time: float) -> void:
	var sun := Vector2(size.x * 0.76, size.y * 0.5)
	glow(canvas, sun, size.x * 0.12, Color("#fde68a"))
	canvas.draw_circle(sun, size.x * 0.08, Color("#fcd34d"))
	ridge(canvas, size, size.y * 0.7, size.y * 0.1, 0.27, Color("#2f5d34"))
	var barn := Vector2(size.x * 0.2, size.y * 0.68)
	box(canvas, barn, Vector2(55.0, 40.0), Color("#8f2d20"))
	shape(canvas, barn, [Vector2(-68, -40), Vector2(0, -82), Vector2(68, -40)], Color("#5b1d16"))
	box(canvas, barn + Vector2(0.0, 14.0), Vector2(18.0, 26.0), Color("#f5deb3"))
	ridge(canvas, size, size.y * 0.8, size.y * 0.05, 0.45, Color("#1f4426"))
	for x in range(10, int(size.x), 60):
		canvas.draw_rect(Rect2(x, size.y * 0.91, 10.0, size.y * 0.06), Color("#8b5a2b"))
	canvas.draw_rect(Rect2(0.0, size.y * 0.925, size.x, 7.0), Color("#8b5a2b"))
	drift(canvas, size, time, 24, 14.0, 2.5, Color("#fef08a"))


static func _ocean(canvas: CanvasItem, size: Vector2, time: float) -> void:
	for i in 4:
		var x: float = size.x * (0.1 + i * 0.27)
		var sway: float = sin(time * 0.5 + i) * 60.0
		canvas.draw_colored_polygon(PackedVector2Array([Vector2(x, 0.0), Vector2(x + 50.0, 0.0), Vector2(x + 170.0 + sway, size.y), Vector2(x - 30.0 + sway, size.y)]), Color(0.7, 0.95, 1.0, 0.06))
	for i in 30:
		var at := Vector2(noise(i, 1.0) * size.x + sin(time * 2.0 + i) * 6.0, fposmod(noise(i, 2.0) * size.y - time * (30.0 + noise(i, 3.0) * 60.0), size.y))
		canvas.draw_arc(at, 3.0 + noise(i, 4.0) * 7.0, 0.0, TAU, 16, Color(1, 1, 1, 0.3), 1.5)
	for i in 14:
		var points := PackedVector2Array()
		for part in 7:
			points.append(Vector2(size.x * i / 13.0 + sin(time * 1.5 + i + part * 0.7) * part * 3.0, size.y - part * (14.0 + noise(i, 5.0) * 12.0)))
		canvas.draw_polyline(points, Color("#0f766e"), 8.0)


static func _synthwave(canvas: CanvasItem, look: Dictionary, size: Vector2, time: float) -> void:
	drift(canvas, Vector2(size.x, size.y * 0.5), time, 35, 4.0, 1.5, Color.WHITE)
	var horizon: float = size.y * 0.62
	var radius: float = size.x * 0.26
	var offset: float = -radius
	while offset < radius:
		var half: float = sqrt(radius * radius - offset * offset)
		if offset < 0.0 or fposmod(offset, 18.0) > 6.0:
			canvas.draw_rect(Rect2(size.x / 2.0 - half, horizon - radius + offset, half * 2.0, 4.0), Color("#ffd319").lerp(Color("#ff2975"), (offset + radius) / (radius * 2.0)))
		offset += 4.0
	gradient(canvas, Rect2(0.0, horizon, size.x, size.y - horizon), Color("#240046"), Color("#0a0015"))
	canvas.draw_line(Vector2(0.0, horizon), Vector2(size.x, horizon), look.glow, 3.0)
	for i in 10:
		var y: float = horizon + (size.y - horizon) * pow(fposmod(i / 10.0 + time * 0.15, 1.0), 2.0)
		canvas.draw_line(Vector2(0.0, y), Vector2(size.x, y), Color(look.accent, 0.6), 2.0)
	for i in range(-9, 10):
		canvas.draw_line(Vector2(size.x / 2.0 + i * 40.0, horizon), Vector2(size.x / 2.0 + i * 180.0, size.y), Color(look.accent, 0.6), 2.0)


static func _winter(canvas: CanvasItem, size: Vector2, time: float) -> void:
	canvas.draw_circle(Vector2(size.x * 0.2, size.y * 0.14), size.x * 0.06, Color("#e0f2fe"))
	ridge(canvas, size, size.y * 0.78, size.y * 0.18, 0.4, Color("#5b7ea8"))
	ridge(canvas, size, size.y * 0.87, size.y * 0.06, 0.25, Color("#b9d3ea"))
	for i in 9:
		var at := Vector2(size.x * (i + 0.5) / 9.0, size.y * (0.9 + noise(i, 6.0) * 0.06))
		for tier in 3:
			shape(canvas, at + Vector2(0.0, -tier * 18.0), [Vector2(-26 + tier * 5, 0), Vector2(0, -32), Vector2(26 - tier * 5, 0)], Color("#134e4a"))
	drift(canvas, size, time, 80, 45.0, 2.5, Color.WHITE)


static func _volcano(canvas: CanvasItem, size: Vector2, time: float) -> void:
	var peak := Vector2(size.x / 2.0, size.y * 0.58)
	glow(canvas, peak, size.x * 0.14, Color("#ff6a1a"))
	canvas.draw_colored_polygon(PackedVector2Array([peak + Vector2(-60.0, 0.0), peak + Vector2(60.0, 0.0), Vector2(size.x * 1.05, size.y), Vector2(-size.x * 0.05, size.y)]), Color("#1c0a0a"))
	oval(canvas, peak, Vector2(60.0, 10.0), Color("#ff8c1a"))
	for flow in [-1.0, 0.35, 1.0]:
		canvas.draw_polyline(PackedVector2Array([peak + Vector2(flow * 30.0, 0.0), peak + Vector2(flow * 55.0, size.y * 0.12), peak + Vector2(flow * 130.0, size.y * 0.22), peak + Vector2(flow * 150.0, size.y * 0.42)]), Color("#ff5a0a"), 6.0)
	ridge(canvas, size, size.y * 0.96, 18.0 + sin(time * 2.0) * 6.0, 0.7, Color("#ea580c"))
	drift(canvas, size, -time, 40, 50.0, 2.5, Color("#fbbf24"))


static func player(canvas: CanvasItem, id: String, at: Vector2, time: float) -> void:
	var flame: float = absf(sin(time * 25.0)) * 7.0
	match id:
		"cosmic":
			shape(canvas, at, [Vector2(-6, 12), Vector2(6, 12), Vector2(0, 19 + flame)], Color("#fb923c"))
			shape(canvas, at, [Vector2(-8, -2), Vector2(-23, 17), Vector2(-8, 11)], Color("#6366f1"))
			shape(canvas, at, [Vector2(8, -2), Vector2(23, 17), Vector2(8, 11)], Color("#6366f1"))
			shape(canvas, at, [Vector2(0, -25), Vector2(9, -9), Vector2(10, 13), Vector2(-10, 13), Vector2(-9, -9)], Color("#e2e8f0"))
			oval(canvas, at + Vector2(0.0, -6.0), Vector2(5.0, 7.0), Color("#22d3ee"))
		"highway":
			_car(canvas, at, Color("#2f8bff"), -1.0, 1.1)
		"farm":
			box(canvas, at + Vector2(-6.0, 19.0), Vector2(4.0, 5.0), Color("#5b3716"))
			box(canvas, at + Vector2(6.0, 19.0), Vector2(4.0, 5.0), Color("#5b3716"))
			box(canvas, at + Vector2(0.0, 6.0), Vector2(18.0, 5.0), Color("#dc2626"))
			box(canvas, at + Vector2(0.0, 8.0), Vector2(11.0, 9.0), Color("#2563eb"))
			canvas.draw_circle(at + Vector2(0.0, -7.0), 10.0, Color("#f2c29b"))
			box(canvas, at + Vector2(-4.0, -7.0), Vector2(1.5, 2.0), Color("#1f2937"))
			box(canvas, at + Vector2(4.0, -7.0), Vector2(1.5, 2.0), Color("#1f2937"))
			oval(canvas, at + Vector2(0.0, -14.0), Vector2(23.0, 5.0), Color("#eab308"))
			shape(canvas, at, [Vector2(-11, -15), Vector2(-8, -24), Vector2(8, -24), Vector2(11, -15)], Color("#facc15"))
			box(canvas, at + Vector2(0.0, -16.0), Vector2(10.0, 1.5), Color("#b91c1c"))
		"ocean":
			canvas.draw_line(at + Vector2(-23.0, 2.0 - flame), at + Vector2(-23.0, 2.0 + flame), Color("#cbd5e1"), 4.0)
			box(canvas, at + Vector2(0.0, -14.0), Vector2(8.0, 7.0), Color("#eab308"))
			box(canvas, at + Vector2(3.0, -23.0), Vector2(5.0, 2.0), Color("#eab308"))
			oval(canvas, at + Vector2(0.0, 3.0), Vector2(23.0, 15.0), Color("#facc15"))
			canvas.draw_circle(at + Vector2(7.0, 2.0), 7.0, Color("#0e7490"))
			canvas.draw_circle(at + Vector2(5.0, 0.0), 3.0, Color("#a5f3fc"))
			canvas.draw_circle(at + Vector2(-10.0, 2.0), 4.0, Color("#0e7490"))
		"synthwave":
			glow(canvas, at, 22.0, Color("#00e5ff"))
			var arrow := PackedVector2Array([at + Vector2(0.0, -24.0), at + Vector2(23.0, 22.0), at + Vector2(0.0, 11.0), at + Vector2(-23.0, 22.0)])
			canvas.draw_colored_polygon(arrow, Color("#083344"))
			outline(canvas, arrow, Color("#00e5ff"), 3.0)
			canvas.draw_line(at + Vector2(0.0, 14.0), at + Vector2(0.0, 20.0 + flame), Color("#ff2bd6"), 4.0)
		"winter":
			oval(canvas, at + Vector2(-18.0, 3.0), Vector2(5.0, 13.0), Color("#111827"), 0.5 + sin(time * 8.0) * 0.2)
			oval(canvas, at + Vector2(18.0, 3.0), Vector2(5.0, 13.0), Color("#111827"), -0.5 - sin(time * 8.0) * 0.2)
			oval(canvas, at + Vector2(0.0, -1.0), Vector2(17.0, 23.0), Color("#111827"))
			oval(canvas, at + Vector2(0.0, 5.0), Vector2(11.0, 15.0), Color("#f8fafc"))
			for x in [-6.0, 6.0]:
				canvas.draw_circle(at + Vector2(x, -12.0), 4.0, Color.WHITE)
				canvas.draw_circle(at + Vector2(x, -11.0), 2.0, Color("#111827"))
				oval(canvas, at + Vector2(x, 22.0), Vector2(6.0, 3.0), Color("#f97316"))
			shape(canvas, at, [Vector2(-5, -7), Vector2(5, -7), Vector2(0, 0)], Color("#f97316"))
		"volcano":
			for x in [-13.0, 13.0]:
				shape(canvas, at + Vector2(x, 0.0), [Vector2(-5, 14), Vector2(5, 14), Vector2(0, 19 + flame)], Color("#38bdf8"))
				box(canvas, at + Vector2(x, 9.0), Vector2(6.0, 7.0), Color("#64748b"))
			oval(canvas, at + Vector2(0.0, -3.0), Vector2(21.0, 19.0), Color("#cbd5e1"))
			box(canvas, at + Vector2(0.0, -5.0), Vector2(14.0, 6.0), Color("#0f172a"))
			box(canvas, at + Vector2(sin(time * 3.0) * 7.0, -5.0), Vector2(4.0, 3.0), Color("#22d3ee"))
			canvas.draw_line(at + Vector2(0.0, -21.0), at + Vector2(0.0, -25.0), Color("#cbd5e1"), 3.0)
		_:
			glow(canvas, at, 26.0 + sin(time * 5.0) * 2.0, Color("#3d8bff"))
			box(canvas, at, Vector2(24.0, 24.0), Color("#7dd3fc"))
			gradient(canvas, Rect2(at - Vector2(20.0, 20.0), Vector2(40.0, 40.0)), Color("#3b82f6"), Color("#1e1b9c"))
			box(canvas, at, Vector2(7.0, 7.0), Color(1, 1, 1, 0.85))


static func enemy(canvas: CanvasItem, id: String, at: Vector2, variant: int, time: float) -> void:
	var spin: float = time * (1.0 + variant % 3) * (1.0 if variant % 2 == 0 else -1.0) + variant
	match id:
		"cosmic":
			var rock := PackedVector2Array()
			for i in 11:
				rock.append(at + Vector2.from_angle(spin + TAU * i / 11.0) * (16.0 + noise(variant + i, 1.0) * 6.0))
			canvas.draw_colored_polygon(rock, Color("#8d6e63"))
			outline(canvas, rock, Color("#d7a98c"), 2.0)
			canvas.draw_circle(at + Vector2.from_angle(spin) * 8.0, 5.0, Color("#5d4037"))
			canvas.draw_circle(at + Vector2.from_angle(spin + 2.6) * 9.0, 3.0, Color("#5d4037"))
		"highway":
			_car(canvas, at, CAR_COLORS[variant % CAR_COLORS.size()], 1.0, 1.0)
		"farm":
			var tilt: float = sin(time * 6.0 + variant) * 0.3
			var egg := PackedVector2Array()
			for i in 20:
				var point := Vector2.from_angle(TAU * i / 20.0)
				egg.append(at + Vector2(point.x * 15.0 * (1.0 + point.y * 0.12), point.y * 20.0).rotated(tilt))
			canvas.draw_colored_polygon(egg, EGG_COLORS[variant % EGG_COLORS.size()])
			outline(canvas, egg, Color("#8b5a2b"), 2.0)
			oval(canvas, at + Vector2(-5.0, -7.0).rotated(tilt), Vector2(3.0, 6.0), Color(1, 1, 1, 0.8), tilt + 0.4)
		"ocean":
			if variant % 2 == 0:
				for i in 8:
					var tip: Vector2 = Vector2.from_angle(spin * 0.4 + TAU * i / 8.0)
					canvas.draw_line(at, at + tip * 21.0, Color("#94a3b8"), 4.0)
					canvas.draw_circle(at + tip * 20.0, 3.0, Color("#cbd5e1"))
				canvas.draw_circle(at, 14.0, Color("#334155"))
				canvas.draw_circle(at, 5.0, Color("#ef4444") if sin(time * 8.0 + variant) > 0.0 else Color("#7f1d1d"))
			else:
				for i in 4:
					var x: float = -12.0 + i * 8.0
					canvas.draw_polyline(PackedVector2Array([at + Vector2(x, 0.0), at + Vector2(x + sin(time * 6.0 + i) * 4.0, 11.0), at + Vector2(x - sin(time * 6.0 + i) * 4.0, 21.0)]), Color("#f9a8d4"), 3.0)
				shape(canvas, at, range(9).map(func(i: int) -> Vector2: return Vector2.from_angle(PI + PI * i / 8.0) * Vector2(19.0, 20.0) + Vector2(0.0, 3.0)), Color("#ec4899"))
				canvas.draw_circle(at + Vector2(-6.0, -7.0), 3.0, Color("#fce7f3"))
				canvas.draw_circle(at + Vector2(6.0, -7.0), 3.0, Color("#fce7f3"))
		"synthwave":
			glow(canvas, at, 20.0, Color("#ff2bd6"))
			var diamond := ring(at, Vector2(23.0, 23.0), spin * 0.6, 4)
			canvas.draw_colored_polygon(diamond, Color("#500724"))
			outline(canvas, diamond, Color("#ff2bd6"), 3.0)
			outline(canvas, ring(at, Vector2(10.0, 10.0), -spin, 4), Color("#ffd319"), 2.0)
		"winter":
			canvas.draw_circle(at, 20.0, Color("#bae6fd"))
			canvas.draw_circle(at + Vector2(-3.0, -3.0), 15.0, Color("#f0f9ff"))
			for i in 3:
				var arm: Vector2 = Vector2.from_angle(spin + PI * i / 3.0) * 11.0
				canvas.draw_line(at - arm, at + arm, Color("#38bdf8"), 2.0)
		"volcano":
			shape(canvas, at, [Vector2(-18, -4), Vector2(-10, -26), Vector2(-4, -18), Vector2(0, -36 - absf(sin(time * 14.0 + variant)) * 10.0), Vector2(6, -19), Vector2(13, -27), Vector2(18, -4)], Color("#f97316"))
			glow(canvas, at, 20.0, Color("#facc15"))
			canvas.draw_circle(at, 19.0, Color("#ea580c"))
			canvas.draw_circle(at, 15.0, Color("#431407"))
			for i in 3:
				canvas.draw_line(at, at + Vector2.from_angle(spin * 0.5 + TAU * i / 3.0) * 13.0, Color("#fbbf24"), 3.0)
		_:
			glow(canvas, at, 22.0, Color("#ff3b5c"))
			box(canvas, at, Vector2(20.0, 20.0), Color("#fda4af"))
			gradient(canvas, Rect2(at - Vector2(17.0, 17.0), Vector2(34.0, 34.0)), Color("#ff3b4e"), Color("#9f1239"))
			box(canvas, at, Vector2(5.0, 5.0), Color(1, 1, 1, 0.5))


static func _car(canvas: CanvasItem, at: Vector2, color: Color, facing: float, zoom: float) -> void:
	var unit := Vector2(zoom, zoom * facing)
	for x in [-15.0, 15.0]:
		for y in [-12.0, 12.0]:
			box(canvas, at + Vector2(x, y) * unit, Vector2(4.0, 6.0) * zoom, Color("#05060a"))
	shape(canvas, at, [Vector2(-10, -22) * unit, Vector2(10, -22) * unit, Vector2(15, -15) * unit, Vector2(15, 17) * unit, Vector2(11, 21) * unit, Vector2(-11, 21) * unit, Vector2(-15, 17) * unit, Vector2(-15, -15) * unit], color)
	shape(canvas, at, [Vector2(-11, 1) * unit, Vector2(11, 1) * unit, Vector2(9, 10) * unit, Vector2(-9, 10) * unit], Color("#bae6fd"))
	box(canvas, at + Vector2(0.0, -11.0) * unit, Vector2(9.0, 4.0) * zoom, Color("#334155"))
	box(canvas, at + Vector2(0.0, -4.0) * unit, Vector2(11.0, 4.0) * zoom, color.darkened(0.25))
	for x in [-8.0, 8.0]:
		box(canvas, at + Vector2(x, 19.0) * unit, Vector2(3.0, 2.0) * zoom, Color("#fef9c3"))
		box(canvas, at + Vector2(x, -20.0) * unit, Vector2(3.0, 1.5) * zoom, Color("#7f1d1d"))
