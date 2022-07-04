import * as THREE from 'https://cdn.skypack.dev/three@0.136.0/build/three.module.js'
import { OrbitControls } from 'https://cdn.skypack.dev/three@0.136.0/examples/jsm/controls/OrbitControls.js'
import { mergeBufferGeometries } from 'https://cdn.skypack.dev/three-stdlib@2.12.1/utils/BufferGeometryUtils';
import SimplexNoise from 'https://cdn.skypack.dev/simplex-noise';
import { GLTFLoader } from 'https://cdn.skypack.dev/three@0.136.0/examples/jsm/loaders/GLTFLoader.js';

/**
 * Initialise a customizable island.
 * @param GRID_RADIUS radius of island
 * @param MAX_HEIGHT maximum height of a block
 * @param STEEPNESS a constant to indicate steepness with 0 being flat and 2 being steep.
 * @param SIMPLEX_SEED seed to generate the island slopes
 * @param RATIOS the ratio of MAX_HEIGHT to assign the texture of each block
 * @param MAX_ANIMAL maximum number of animals rendered
 * @param ANIMAL_LS array of type of animals to spawn
 * Available animals : alpaca, bull, cow, deer, donkey, fox, horse_white, horse, stag, wolf
 * @param ENV_LS array of enivironmental objects to spawn
 * Available objects : birch, tree, palm, pine, rock
 * @param dayBool indicates daytime lighting
 */
async function init(
    GRID_RADIUS = 7, 
    MAX_HEIGHT = 10,
    STEEPNESS = 1, 
    SIMPLEX_SEED = 'seed', 
    RATIOS = [0.0, 0.275, 0.45, 0.7, 0.8],
    MAX_ANIMAL = 7,
    ANIMAL_LS = ['cow', 'bull'],
    ENV_LS = ['palm', 'tree', 'rock'],
    dayBool = true,
    cloudBool = true
    )  {
    // --------------------
    // SCENE and CAMERA
    // --------------------
    const scene = new THREE.Scene();
    scene.background = new THREE.Color("#E5EBED");
    const camera = new THREE.PerspectiveCamera( 75, window.innerWidth / window.innerHeight, 0.1, 1000 );
    camera.position.z = 50;

    // --------------------
    // RENDERER
    // --------------------
    const renderer = new THREE.WebGLRenderer({antialias: true});
    renderer.setSize( window.innerWidth, window.innerHeight );
    renderer.toneMapping = THREE.ACESFilmicToneMapping;
    renderer.outputEncoding = THREE.sRGBEncoding;
    renderer.physicallyCorrectLights = true;
    renderer.shadowMap.enabled = true;
    renderer.shadowMap.type = THREE.PCFSoftShadowMap;
    document.body.appendChild(renderer.domElement);

    // --------------------
    // LIGHT
    // --------------------
    const dayTime = new THREE.Color("#FFCB8E").convertSRGBToLinear();
    const nightTime = new THREE.Color("#4C96E6").convertSRGBToLinear();
    const dayIntensity = 40;
    const nightIntensity = 20;

    const light = new THREE.PointLight( dayTime, dayBool ? dayIntensity : nightIntensity, 200);
    light.position.set(0, 20, 20);
    light.castShadow = true; 
    light.shadow.mapSize.width = 512; 
    light.shadow.mapSize.height = 512; 
    light.shadow.camera.near = 0.5; 
    light.shadow.camera.far = 500; 
    scene.add(light);

    const hemisphereLight = new THREE.HemisphereLight(dayBool ? dayTime : nightTime, new THREE.Color("#094B17").convertSRGBToLinear(), 1);
    hemisphereLight.position.set(0, 30, 0);
    scene.add(hemisphereLight);

    // --------------------
    // CONTROLS
    // --------------------
    const controls = new OrbitControls(camera, renderer.domElement);
    controls.target.set(0, 0, 0);
    controls.dampingFactor = 0.05;
    controls.enableDamping = true;

    // --------------------
    // ISLAND GRID and GEOMETRIES
    // --------------------
    const SIMPLEX = new SimplexNoise(SIMPLEX_SEED);

    let DIRT2_HEIGHT = MAX_HEIGHT * RATIOS[0];
    let SAND_HEIGHT = MAX_HEIGHT * RATIOS[1];
    let GRASS_HEIGHT = MAX_HEIGHT * RATIOS[2];
    let DIRT_HEIGHT = MAX_HEIGHT * RATIOS[3];
    let STONE_HEIGHT = MAX_HEIGHT * RATIOS[4];

    let DIRT2_GRID  = new THREE.BoxGeometry(0, 0, 0);
    let SAND_GRID  = new THREE.BoxGeometry(0, 0, 0);
    let GRASS_GRID  = new THREE.BoxGeometry(0, 0, 0);
    let DIRT_GRID  = new THREE.BoxGeometry(0, 0, 0);
    let STONE_GRID  = new THREE.BoxGeometry(0, 0, 0);

    let DIRT2_MESH;
    let SAND_MESH;
    let GRASS_MESH;
    let DIRT_MESH;
    let STONE_MESH;

    let map = {
    dirt: await new THREE.TextureLoader().loadAsync("textures/Ground048_1K-JPG/Ground048_1K_Color.jpg"),
    dirt2: await new THREE.TextureLoader().loadAsync("textures/Gravel024_1K-JPG/Gravel024_1K_Color.jpg"),
    grass: await new THREE.TextureLoader().loadAsync("textures/Grass001_1K-JPG/Grass001_1K_Color.jpg"),
    sand: await new THREE.TextureLoader().loadAsync("textures/Ground054_1K-JPG/Ground054_1K_Color.jpg"),
    water: await new THREE.TextureLoader().loadAsync("textures/water.jpg"),
    stone: await new THREE.TextureLoader().loadAsync("textures/Rock030_1K-JPG/Rock030_1K_Color.jpg"),
    };
    
    let aoMap = {
    dirt: await new THREE.TextureLoader().loadAsync("textures/Ground048_1K-JPG/Ground048_1K_AmbientOcclusion.jpg"),
    dirt2: await new THREE.TextureLoader().loadAsync("textures/Gravel024_1K-JPG/Gravel024_1K_AmbientOcclusion.jpg"),
    grass: await new THREE.TextureLoader().loadAsync("textures/Grass001_1K-JPG/Grass001_1K_AmbientOcclusion.jpg"),
    sand: await new THREE.TextureLoader().loadAsync("textures/Ground054_1K-JPG/Ground054_1K_AmbientOcclusion.jpg"),
    stone: await new THREE.TextureLoader().loadAsync("textures/Rock030_1K-JPG/Rock030_1K_AmbientOcclusion.jpg"),
    };

    let DIRT2_MATERIAL = makeHexMaterial(map.dirt2, aoMap.dirt2);
    let SAND_MATERIAL = makeHexMaterial(map.sand, aoMap. sand);
    let GRASS_MATERIAL = makeHexMaterial(map.grass, aoMap.grass);
    let DIRT_MATERIAL = makeHexMaterial(map.dirt, aoMap.dirt);
    let STONE_MATERIAL = makeHexMaterial(map.stone, aoMap.stone);

    // Emulator webview does not load object with MeshStandardMaterial
    function makeHexGeometry(height, posX, poxY) {
        const hex = new THREE.CylinderGeometry(1, 1, height, 6, 1, false);
        hex.translate(posX, height * 0.5, poxY);
        return hex;
    }

    function makeHexMaterial(map, aoMap) {
        let material = new THREE.MeshStandardMaterial( {
            flatShading: true, 
            map: map, 
        });
        material.aoMap = aoMap;
        return material;
    }

    function addHexToGrid(height, posX, posY) {
        const hex = makeHexGeometry(height, posX, posY);
        if (height >= STONE_HEIGHT) {
            STONE_GRID = mergeBufferGeometries([ STONE_GRID, hex]);
            if (ENV_BOOL.pine && Math.random() >= 0.9) {
                // spawn pine
                spawnPineTree(posX, height, posY);
            } else if (ANIMALS_BOOL.wolf && Math.random() >= 0.95) {
                // spawn wolf
                modelLoaderWithAnimation(ANIMAL_LIST.wolf, posX, height, posY);
            } else if (ANIMALS_BOOL.fox && Math.random() >= 0.95) {
                // spawn fox
                modelLoaderWithAnimation(ANIMAL_LIST.fox, posX, height, posY);
            } else if (ANIMALS_BOOL.alpaca && Math.random() >= 0.95) {
                // spawn alpaca
                modelLoaderWithAnimation(ANIMAL_LIST.alpaca, posX, height, posY);
            }
        } else if (height >= DIRT_HEIGHT) {
            DIRT_GRID = mergeBufferGeometries([ DIRT_GRID, hex]);
            if (ENV_BOOL.pine && Math.random() >= 0.8) {
                // spawn pine
                spawnPineTree(posX, height, posY);
            } else if (ENV_BOOL.birch && Math.random() >= 0.8) {
                // spawn birch
                spawnBirchTree(posX, height, posY);
            } else if (ANIMALS_BOOL.bull && Math.random() >= 0.95) {
                // spawn bull
                modelLoaderWithAnimation(ANIMAL_LIST.bull, posX, height, posY);
            } else if (ANIMALS_BOOL.fox && Math.random() >= 0.95) {
                // spawn fox
                modelLoaderWithAnimation(ANIMAL_LIST.fox, posX, height, posY);
            }
        } else if (height >= GRASS_HEIGHT) {
            GRASS_GRID = mergeBufferGeometries([ GRASS_GRID, hex]);
            if (ENV_BOOL.tree && Math.random() >= 0.8) {
                // spawn common tree
                spawnCommonTree(posX, height, posY);
            }  else if (ENV_BOOL.birch && Math.random() >= 0.8) {
                // spawn birch
                spawnBirchTree(posX, height, posY);
            } else if (ANIMALS_BOOL.deer && Math.random() >= 0.95) {
                // spawn deer
                modelLoaderWithAnimation(ANIMAL_LIST.deer, posX, height, posY);
            } else if (ANIMALS_BOOL.cow && Math.random() >= 0.95) {
                // spawn cow
                modelLoaderWithAnimation(ANIMAL_LIST.cow, posX, height, posY);
            } else if (ANIMALS_BOOL.donkey && Math.random() >= 0.95) {
                // spawn donkey
                modelLoaderWithAnimation(ANIMAL_LIST.donkey, posX, height, posY);
            } else if (ANIMALS_BOOL.horse && Math.random() >= 0.95) {
                // spawn horse
                modelLoaderWithAnimation(ANIMAL_LIST.horse, posX, height, posY);
            }  else if (ANIMALS_BOOL.stag && Math.random() >= 0.95) {
                // spawn stag
                modelLoaderWithAnimation(ANIMAL_LIST.stag, posX, height, posY);
            }
        } else if (height >= SAND_HEIGHT) {
            SAND_GRID = mergeBufferGeometries([ SAND_GRID, hex]);
            if (ENV_BOOL.palm && Math.random() >= 0.9) {
                // spawn palm
                spawnPalmTree(posX, height, posY);
            } 
            if (ENV_BOOL.rock && Math.random() >= 0.9) {
                // spawn rock
                spawnRock(posX, height, posY);
            } 
        } else {
            DIRT2_GRID = mergeBufferGeometries([ DIRT2_GRID, hex]);
        }
    }

    function tilePositionToCoordinate(posX, posY) {
        // offset coordinate system
        const result = new THREE.Vector2((posX + (posY % 2) * 0.5) * 1.77, posY * 1.535);
        return result;
    }

    function getMesh(geometry, material) {
        let mesh = new THREE.Mesh(geometry, material);
        mesh.castShadow = true;
        mesh.receiveShadow = true; 
        return mesh;
    }

    function setMesh() {
        DIRT2_MESH = getMesh(DIRT2_GRID, DIRT2_MATERIAL)
        SAND_MESH = getMesh(SAND_GRID, SAND_MATERIAL);
        GRASS_MESH = getMesh(GRASS_GRID, GRASS_MATERIAL);
        DIRT_MESH = getMesh(DIRT_GRID, DIRT_MATERIAL);
        STONE_MESH = getMesh(STONE_GRID, STONE_MATERIAL);
    }

    function addMeshToScene() {
        scene.add(DIRT2_MESH, SAND_MESH, GRASS_MESH, DIRT_MESH, STONE_MESH);
    }
    
    // --------------------
    // SEA GRID and GEOMETRIES
    // --------------------
    let seaTexture = map.water;
    seaTexture.repeat = new THREE.Vector2(1, 1);
    seaTexture.wrapS = THREE.RepeatWrapping;
    seaTexture.wrapT = THREE.RepeatWrapping;

    let SEA_MESH = new THREE.Mesh(
        new THREE.CylinderGeometry(GRID_RADIUS * 2.2, GRID_RADIUS * 2.2, MAX_HEIGHT * 0.2, 50),
        new THREE.MeshPhysicalMaterial({
        color: new THREE.Color("#55aaff").convertSRGBToLinear().multiplyScalar(3),
        ior: 1.4,
        transmission: 1,
        transparent: true,
        thickness: 1.5,
        envMapIntensity: 0.2, 
        roughness: 1,
        metalness: 0.025,
        roughnessMap: seaTexture,
        metalnessMap: seaTexture,
        })
    );
    SEA_MESH.receiveShadow = true;
    SEA_MESH.rotation.y = -Math.PI * 0.333 * 0.5;
    SEA_MESH.position.set(0, MAX_HEIGHT * 0.1, 0);
    scene.add(SEA_MESH);

    // --------------------
    // SEA FLOOR and GEOMETRIES
    // --------------------
    let FLOOR_MESH = new THREE.Mesh(
        new THREE.CylinderGeometry(GRID_RADIUS * 2.2, GRID_RADIUS * 2.2, MAX_HEIGHT * 0.3, 50),
        new THREE.MeshPhysicalMaterial({
        map: map.dirt2,
        side: THREE.doubleSide,
        })
    );
    FLOOR_MESH.receiveShadow = true;
    FLOOR_MESH.position.set(0, -MAX_HEIGHT * 0.05, 0);
    scene.add(FLOOR_MESH);

    // --------------------
    // ANIMALS 3D MODELS AND ANIMATION
    // --------------------
    const loader = new GLTFLoader();
    const clock = new THREE.Clock();
    const ACTIONS_NAME = ['Eating','Idle', 'Idle_2'];
    const ANIMAL_LIST = {
        alpaca: 'models/animals/Alpaca.gltf', 
        bull: 'models/animals/Bull.gltf',
        cow: 'models/animals/Cow.gltf',
        deer: 'models/animals/Deer.gltf',
        donkey: 'models/animals/Donkey.gltf',
        fox: 'models/animals/Fox.gltf',
        horse_white: 'models/animals/Horse_White.gltf',
        horse: 'models/animals/Horse.gltf',
        stag: 'models/animals/Stag.gltf',
        wolf: 'models/animals/Wolf.gltf'
    };
    const ANIMAL_SCALE_FACTOR = 0.1;
    const INTERVAL_MS = 3000;
    let MIXERS = [];
    let counter = 0;

    let ANIMALS_BOOL = structuredClone(ANIMAL_LIST);

    Object.keys(ANIMALS_BOOL).forEach(key => {
        ANIMALS_BOOL[key] = ANIMAL_LS.includes(key.toString());
    });
    console.log(ANIMALS_BOOL);

    function modelLoaderWithAnimation(url, posX, height, posY) {
        if (counter >= MAX_ANIMAL) return;
        counter++;
        loader.load(url, function ( gltf ) {
        let model = gltf.scene;

        model.position.set(posX, height, posY);
        model.scale.set(ANIMAL_SCALE_FACTOR, ANIMAL_SCALE_FACTOR, ANIMAL_SCALE_FACTOR);
        model.rotateY(Math.random() * Math.PI * 2.0);

        model.traverse(function(node) {
            if (node.isMesh) {node.castShadow = true;}
        });

        const mixer = new THREE.AnimationMixer(model);
        let clip = ACTIONS_NAME.map(str => THREE.AnimationClip.findByName(
            gltf.animations, str))[Math.floor(Math.random() * ACTIONS_NAME.length)];
        let action = mixer.clipAction(clip);
        action.loop = THREE.LoopOnce;
        setInterval(() => {
        action.reset().play();
        }, Math.random() * INTERVAL_MS + clip.duration * 1000);

        MIXERS.push(mixer);
        scene.add(model);
    }, function (xhr) {
        console.log( ( xhr.loaded / xhr.total * 100 ) + '% loaded' );
    }, function (error) {
        console.error(error);
    } );
    }

    // --------------------
    // TREES AND ROCKS 3D MODELS
    // --------------------
    const ENV_SCALE_FACTOR = 0.5;
    const ENV_LIST = {
        birch: ['models/environment/BirchTree_1.gltf', 'models/environment/BirchTree_2.gltf', 'models/environment/BirchTree_3.gltf'],
        tree : ['models/environment/CommonTree_1.gltf', 'models/environment/CommonTree_2.gltf'],
        palm : ['models/environment/PalmTree_1.gltf', 'models/environment/PalmTree_2.gltf'],
        pine : ['models/environment/PineTree_1.gltf', 'models/environment/PineTree_2.gltf'],
        rock : ['models/environment/Rock_1.gltf', 'models/environment/Rock_2.gltf', 'models/environment/Rock_3.gltf','models/environment/Rock_4.gltf']
    };

    let ENV_BOOL = structuredClone(ENV_LIST);
    Object.keys(ENV_BOOL).forEach(key => {
        ENV_BOOL[key] = ENV_LS.includes(key.toString());
    });
    let env_group = new THREE.Group;

    function modelLoader(url, posX, height, posY) {
        loader.load(url, function ( gltf ) {
        let model = gltf.scene;

        model.position.set(posX, height, posY);
        model.scale.set(ENV_SCALE_FACTOR, ENV_SCALE_FACTOR, ENV_SCALE_FACTOR);
        model.rotateY(Math.random() * Math.PI * 2.0);

        model.traverse(function(node) {
            if (node.isMesh) {node.castShadow = true;}
        });
        env_group.add(model);
    }, function (xhr) {
        console.log( ( xhr.loaded / xhr.total * 100 ) + '% loaded' );
    }, function (error) {
        console.error(error);
    } );
    }

    function spawnRock(posX, height, posY) {
        let urlList = ENV_LIST.rock;
        let url = urlList[Math.floor(Math.random() * urlList.length)];
        modelLoader(url, Math.random() - 0.5 + posX, height, Math.random() - 0.5 + posY);
    }

    function spawnBirchTree(posX, height, posY) {
        let urlList = ENV_LIST.birch;
        let url = urlList[Math.floor(Math.random() * urlList.length)];
        modelLoader(url, posX, height, posY);
    }

    function spawnCommonTree(posX, height, posY) {
        let urlList = ENV_LIST.tree;
        let url = urlList[Math.floor(Math.random() * urlList.length)];
        modelLoader(url, posX, height, posY);
    }

    function spawnPalmTree(posX, height, posY) {
        let urlList = ENV_LIST.palm;
        let url = urlList[Math.floor(Math.random() * urlList.length)];
        modelLoader(url, posX, height, posY);
    }

    function spawnPineTree(posX, height, posY) {
        let urlList = ENV_LIST.pine;
        let url = urlList[Math.floor(Math.random() * urlList.length)];
        modelLoader(url, posX, height, posY);
    }

    // --------------------
    // CLOUDS
    // --------------------
    let CLOUD_MESH;
    let count = 2;

    function chopBottom(geometry, bottom) {
        let position = geometry.attributes.position.array;
        for (let i = 0; i < position.length; i++) {
            if (i%3 == 0) {
                position[i] += Math.max(position[i], bottom);
            }  
        }
    }

    function cloud(height, posX, posY) {
        let geo = new THREE.SphereGeometry(0, 0, 0);
        
        for (let i = 0; i < count; i++) {
            const puff1 = new THREE.SphereGeometry(1.2, 5, 5);
            const puff2 = new THREE.SphereGeometry(1.2, 5, 5);
            const puff3 = new THREE.SphereGeometry(1.5, 5, 5);

            puff1.translate(-1.5, Math.random() * 0.3, 0);
            puff2.translate(1, Math.random() * 0.3, 0);
            puff3.translate(0, Math.random() * 0.3, 0);

            const cloudGeo = mergeBufferGeometries([puff1, puff2, puff3]);

            chopBottom(cloudGeo,  Math.random() * -0.5);

            let position = new THREE.Vector2(
                (Math.random() * 2 - 1) * GRID_RADIUS * 1.5, 
                (Math.random() * 2 - 1) * GRID_RADIUS * 1.5);
            while (position.length() >  GRID_RADIUS * 1.8) {
                position = new THREE.Vector2(
                (Math.random() * 2 - 1) * GRID_RADIUS * 1.5, 
                (Math.random() * 2 - 1) * GRID_RADIUS * 1.5);
            }
            cloudGeo.translate(position.x, Math.random() * 3 + MAX_HEIGHT, position.y);
            cloudGeo.rotateY(Math.random() * Math.PI / 3);
            geo = mergeBufferGeometries([geo, cloudGeo]);
        }   
        CLOUD_MESH = new THREE.Mesh(
                geo,
                new THREE.MeshLambertMaterial({
                    color:new THREE.Color("#636364").convertSRGBToLinear(),
                    })
            );
        scene.add(CLOUD_MESH); 
    }

    // --------------------
    // INITIALISER & ANIMATOR
    // --------------------
    const ROTATION_SPEED = 0.001;

    for (let i = -1 * GRID_RADIUS; i <= GRID_RADIUS; i++) {
        for (let j = -1 * GRID_RADIUS; j <= GRID_RADIUS; j++) {
            const coordinate = tilePositionToCoordinate(i, j);
            // conditional to make hexagon shaped grid
            if (coordinate.length() <= GRID_RADIUS * 1.8) {
                let multiplyer = (SIMPLEX.noise2D(i * 0.1, j * 0.1) + 1) * 0.5;  
                // make mountain steeper
                multiplyer = Math.pow(multiplyer, STEEPNESS);
                addHexToGrid(multiplyer * MAX_HEIGHT, coordinate.x, coordinate.y);
                
            }
        }
    }

    setMesh();
    addMeshToScene();
    if (cloudBool) cloud();
    scene.add(env_group);
    

    const animate = function () {
        requestAnimationFrame(animate);
        CLOUD_MESH.rotation.y += ROTATION_SPEED;
        let delta = clock.getDelta();
        for (let i = 0; i < MIXERS.length; i++) {
            MIXERS[i].update(delta);
        }
        controls.update();
        renderer.render(scene,camera);
    };

    animate();
}

messageHandler.postMessage('Requesting Island Data ...');

// create global variable
window.init = init;