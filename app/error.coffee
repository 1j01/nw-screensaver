
container = undefined
camera = undefined
scene = undefined
renderer = undefined
group = undefined
targetRotation = 0
targetRotationOnMouseDown = 0
mouseX = 0
mouseXOnMouseDown = 0
windowCenterX = window.innerWidth / 2
windowCenterY = window.innerHeight / 2

init = ->

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
		mesh.position.set x, y, z #- 75
		mesh.rotation.set rx, ry, rz
		mesh.scale.set s, s, s
		group.add mesh
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

	container = document.createElement('div')
	document.body.appendChild container
	scene = new (THREE.Scene)
	camera = new (THREE.PerspectiveCamera)(20, window.innerWidth / window.innerHeight, 1, 1000)
	camera.position.set 0, 100, 500
	scene.add camera
	light = new (THREE.PointLight)(0xffffff, 0.8)
	camera.add light
	group = new (THREE.Group)
	group.position.y = 50
	scene.add group
	
	# Triangle
	
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
		amount: 4
		bevelEnabled: yes
		bevelSegments: 2
		steps: 1
		bevelSize: 2
		bevelThickness: 5
	
	# addShape( shape, color, x, y, z, rx, ry,rz, s );
	addShape triangleShape, extrudeSettings, 0xffe030, 0, 0, 0, 0, 0, 0, 1
	#
	renderer = new THREE.WebGLRenderer(antialias: yes)
	#renderer.setClearColor 0xf0f0f0
	renderer.setPixelRatio window.devicePixelRatio
	renderer.setSize window.innerWidth, window.innerHeight
	container.appendChild renderer.domElement
	document.addEventListener 'mousedown', onDocumentMouseDown, false
	document.addEventListener 'touchstart', onDocumentTouchStart, false
	document.addEventListener 'touchmove', onDocumentTouchMove, false
	#
	window.addEventListener 'resize', onWindowResize, false
	return

onWindowResize = ->
	windowCenterX = window.innerWidth / 2
	windowCenterY = window.innerHeight / 2
	camera.aspect = window.innerWidth / window.innerHeight
	camera.updateProjectionMatrix()
	renderer.setSize window.innerWidth, window.innerHeight
	return

#

onDocumentMouseDown = (event) ->
	event.preventDefault()
	document.addEventListener 'mousemove', onDocumentMouseMove, false
	document.addEventListener 'mouseup', onDocumentMouseUp, false
	document.addEventListener 'mouseout', onDocumentMouseOut, false
	mouseXOnMouseDown = event.clientX - windowCenterX
	targetRotationOnMouseDown = targetRotation
	return

onDocumentMouseMove = (event) ->
	mouseX = event.clientX - windowCenterX
	targetRotation = targetRotationOnMouseDown + (mouseX - mouseXOnMouseDown) * 0.02
	return

onDocumentMouseUp = (event) ->
	document.removeEventListener 'mousemove', onDocumentMouseMove, false
	document.removeEventListener 'mouseup', onDocumentMouseUp, false
	document.removeEventListener 'mouseout', onDocumentMouseOut, false
	return

onDocumentMouseOut = (event) ->
	document.removeEventListener 'mousemove', onDocumentMouseMove, false
	document.removeEventListener 'mouseup', onDocumentMouseUp, false
	document.removeEventListener 'mouseout', onDocumentMouseOut, false
	return

onDocumentTouchStart = (event) ->
	if event.touches.length == 1
		event.preventDefault()
		mouseXOnMouseDown = event.touches[0].pageX - windowCenterX
		targetRotationOnMouseDown = targetRotation
	return

onDocumentTouchMove = (event) ->
	if event.touches.length == 1
		event.preventDefault()
		mouseX = event.touches[0].pageX - windowCenterX
		targetRotation = targetRotationOnMouseDown + (mouseX - mouseXOnMouseDown) * 0.05
	return

#
animate = ->
	requestAnimationFrame animate
	render()
	return

render = ->
	group.rotation.y += (targetRotation - group.rotation.y) * 0.05
	renderer.render scene, camera
	return

init()
animate()

