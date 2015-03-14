
addShape = (shape, extrudeSettings, color, x, y, z, rx, ry, rz, s) ->
	points = shape.createPointsGeometry()
	
	geometry = new THREE.ExtrudeGeometry shape, extrudeSettings

	mesh = new THREE.Mesh geometry, new THREE.MeshPhongMaterial
		color: color
		ambient: color
	
	mesh.position.set x, y + 50, z
	mesh.rotation.set rx, ry, rz
	mesh.scale.set s, s, s
	scene.add mesh
	
	return mesh

warnings = []

class Warning extends THREE.Object3D
	constructor: (thickness=10)->
		super()
		
		triangleShape = new THREE.Shape
		triangleShape.moveTo 0, 80
		triangleShape.lineTo -50, 0
		triangleShape.lineTo +50, 0
		
		dot = new THREE.Path
		dot.absellipse 0, 12, 8, 8, 0, Math.PI * 2, true
		triangleShape.holes.push dot
		
		mark = new THREE.Path
		
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
		
		# addShape shape, color, x, y, z, rx, ry, rz, s
		mesh = addShape triangleShape, extrudeSettings, 0xfff000, 0, 0, 0, 0, 0, 0, 1
		mesh.position.y = -25
		@add mesh
		scene.add @
		warnings.push @
		@vx = 1
		@vy = 1
	
	update: ->
		@position.x += @vx
		@position.y += @vy
		boundary_width = (window.innerWidth - 150)/5
		boundary_height = (window.innerHeight - 150)/5
		@vx = -1 if @position.x > +boundary_width/2
		@vx = +1 if @position.x < -boundary_width/2
		@vy = -1 if @position.y > +boundary_height/2
		@vy = +1 if @position.y < -boundary_height/2
		@rotation.y += 0.04
		@rotation.x += 0.02
		@rotation.z += 0.01



scene = new THREE.Scene

camera = new THREE.PerspectiveCamera(20, window.innerWidth / window.innerHeight, 1, 1000)
camera.position.set 0, 0, 500
scene.add camera
light = new THREE.PointLight(0xffffff, 0.8)
camera.add light
new Warning

renderer = new THREE.WebGLRenderer(antialias: yes, alpha: yes)
renderer.setPixelRatio window.devicePixelRatio
renderer.setSize window.innerWidth, window.innerHeight
document.body.appendChild renderer.domElement

window.addEventListener 'resize', onWindowResize, false


onWindowResize = ->
	camera.aspect = window.innerWidth / window.innerHeight
	camera.updateProjectionMatrix()
	renderer.setSize window.innerWidth, window.innerHeight
	return

render = ->
	warning.update() for warning in warnings
	renderer.render scene, camera
	return

do animate = ->
	requestAnimationFrame animate
	render()
	return

