
camera = undefined
scene = undefined
renderer = undefined


addShape = (shape, extrudeSettings, color, x, y, z, rx, ry, rz, s) ->
	`var pgeo`
	`var line`
	console.log shape
	points = shape.createPointsGeometry()
	#points.mergeVertices()
	#spacedPoints = shape.createSpacedPointsGeometry(50)
	# flat shape
	# geometry = new THREE.ShapeGeometry shape
	# mesh = new THREE.Mesh geometry, new THREE.MeshPhongMaterial
	# 	color: color
	# 	ambient: color
	# 	side: THREE.DoubleSide
	# mesh.position.set x, y, z - 125
	# mesh.rotation.set rx, ry, rz
	# mesh.scale.set s, s, s
	# group.add mesh
	# 3d shape
	geometry = new THREE.ExtrudeGeometry shape, extrudeSettings
	######
	# #geometry.computeVertexNormals()
	# #geometry.computeFaceNormals()
	# geometry.mergeVertices()
	# modifier = new THREE.SubdivisionModifier 3
	# modifier.modify geometry
	######

	mesh = new THREE.Mesh geometry, new THREE.MeshPhongMaterial
		color: color
		ambient: color
	mesh.position.set x, y + 50, z
	mesh.rotation.set rx, ry, rz
	mesh.scale.set s, s, s
	scene.add mesh
	# # solid line
	# line = new THREE.Line points, new THREE.LineBasicMaterial
	# 	color: color
	# 	linewidth: 3
	# line.position.set x, y, z - 25
	# line.rotation.set rx, ry, rz
	# line.scale.set s, s, s
	# group.add line
	# # vertices from real points
	# pgeo = points.clone()
	# particles = new THREE.PointCloud pgeo, new THREE.PointCloudMaterial
	# 	color: color
	# 	size: 4
	# particles.position.set x, y, z + 25
	# particles.rotation.set rx, ry, rz
	# particles.scale.set s, s, s
	# group.add particles
	# # line from equidistance sampled points
	# line = new THREE.Line spacedPoints, new THREE.LineBasicMaterial
	# 	color: color
	# 	linewidth: 3
	# line.position.set x, y, z + 75
	# line.rotation.set rx, ry, rz
	# line.scale.set s, s, s
	# group.add line
	# # equidistance sampled points
	# pgeo = spacedPoints.clone()
	# particles2 = new THREE.PointCloud pgeo, new THREE.PointCloudMaterial
	# 	color: color
	# 	size: 4
	# particles2.position.set x, y, z + 125
	# particles2.rotation.set rx, ry, rz
	# particles2.scale.set s, s, s
	# group.add particles2
	# return
	return mesh

warnings = []

class Warning extends THREE.Object3D
	constructor: (thickness=10)->
		super()
		
		triangleShape = new (THREE.Shape)
		triangleShape.moveTo 0, 80
		triangleShape.lineTo -50, 0
		triangleShape.lineTo +50, 0
		
		dot = new (THREE.Path)
		dot.absellipse 0, 12, 8, 8, 0, Math.PI * 2, true
		triangleShape.holes.push dot
		
		mark = new (THREE.Path)
		
		x = 0
		y = 22
		width_top = 15
		width_bottom = 10.1 # this MUST be greater than radius * 2
		height = 40
		radius = 5
		
		mark.moveTo x - width_bottom/2, y + radius
		mark.lineTo x - width_top/2, y + height - radius
		mark.quadraticCurveTo x - width_top/2, y + height, x - width_top/2 + radius, y + height
		mark.lineTo x + width_top/2 - radius, y + height
		mark.quadraticCurveTo x + width_top/2, y + height, x + width_top/2, y + height - radius
		mark.lineTo x + width_bottom/2, y + radius
		mark.quadraticCurveTo x + width_bottom/2, y, x + width_bottom/2 - radius, y
		mark.lineTo x - width_bottom/2 + radius, y
		mark.quadraticCurveTo x - width_bottom/2, y, x - width_bottom/2, y + radius
		triangleShape.holes.push mark
		
		extrudeSettings =
			curveSegments: 20
			amount: 0
			bevelEnabled: yes
			steps: 1
			bevelSegments: 10
			bevelSize: 2
			bevelThickness: thickness
		
		# addShape( shape, color, x, y, z, rx, ry,rz, s );
		mesh = addShape triangleShape, extrudeSettings, 0xfff000, 0, 0, 0, 0, 0, 0, 1
		mesh.position.y = -25
		@.add mesh
		scene.add @
		warnings.push @
		@vx = 1
		@vy = 1
	update: ->
		@.position.x += @vx
		@.position.y += @vy
		boundary_width = (window.innerWidth - 150)/5
		boundary_height = (window.innerHeight - 150)/5
		@vx = -1 if @.position.x > +boundary_width/2
		@vx = +1 if @.position.x < -boundary_width/2
		@vy = -1 if @.position.y > +boundary_height/2
		@vy = +1 if @.position.y < -boundary_height/2
		@.rotation.y += 0.04
		@.rotation.x += 0.02
		@.rotation.z += 0.01


init = ->

	scene = new (THREE.Scene)
	
	camera = new (THREE.PerspectiveCamera)(20, window.innerWidth / window.innerHeight, 1, 1000)
	camera.position.set 0, 0, 500
	scene.add camera
	light = new (THREE.PointLight)(0xffffff, 0.8)
	camera.add light
	new Warning
	
	renderer = new THREE.WebGLRenderer(antialias: yes, alpha: yes)
	#renderer.setClearColor 0xf0f0f0, 0
	renderer.setPixelRatio window.devicePixelRatio
	renderer.setSize window.innerWidth, window.innerHeight
	document.body.appendChild renderer.domElement
	
	window.addEventListener 'resize', onWindowResize, false
	return

onWindowResize = ->
	camera.aspect = window.innerWidth / window.innerHeight
	camera.updateProjectionMatrix()
	renderer.setSize window.innerWidth, window.innerHeight
	return

#

#
animate = ->
	requestAnimationFrame animate
	render()
	return

render = ->
	warning.update() for warning in warnings
	renderer.render scene, camera
	return

init()
animate()

