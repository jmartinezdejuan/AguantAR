//
//  GameViewController.swift
//  AguantAR
//
//  Created by Jesus M Martínez de Juan on 28/5/18.
//  Copyright © 2018 CHECHU. All rights reserved.
//

import UIKit
import ARKit
import SpriteKit
import ReplayKit

struct PhysicsMask {
    static let playerBullet = 0
    static let enemyBullet = 1
    static let enemy = 2
}

enum TipoEnemigo  {
    case player
    case enemy
}

class GameViewController: UIViewController, GameDelegate{
    
    
    @IBOutlet var sceneView : ARSCNView!
    var enemigos = [EnemigoN]()
    var proyectiles = [ProyectilN]()
    var game = Game()
    
    // Las siguientes 3 variables definen como deben salir en la pantalla los labels
    lazy var paragraphStyle : NSParagraphStyle = {
        let style = NSMutableParagraphStyle()
        style.alignment = NSTextAlignment.left
        return style
    }()
    //para el SCORE y las VIDAS
    lazy var stringAttributes : [NSAttributedStringKey : Any] = [.strokeColor : UIColor.black, .strokeWidth : -4, .foregroundColor: UIColor.white, .font : UIFont.systemFont(ofSize: 20, weight: .bold), .paragraphStyle : paragraphStyle]
    //para cuando ganas o pierdes
    lazy var titleAttributes : [NSAttributedStringKey : Any] = [.strokeColor : UIColor.black, .strokeWidth : -4, .foregroundColor: UIColor.white, .font : UIFont.systemFont(ofSize: 50, weight: .bold), .paragraphStyle : paragraphStyle]
    
    // Nodos de la escena
    var scoreNode : SKLabelNode!
    var livesNode : SKLabelNode!
    var winNode : SKLabelNode!
    var radarNode : SKShapeNode!
    var norteNode : SKShapeNode!
    
    let topPadding : CGFloat = 40
    let sidePadding : CGFloat = 20
    
    
    //MARK: GameDelegate Functions
    
    func scoreDidChange() {
        scoreNode.attributedText = NSMutableAttributedString(string: "Puntos: \(game.score)", attributes: stringAttributes)
        if game.score >= game.goalScore {
            game.winLoseFlag = true
            showFinish()
        }
    }
    
    func healthDidChange() {
        
        livesNode.attributedText = NSAttributedString(string: "Vida: \(game.health)", attributes: stringAttributes)
        if game.health <= 0 {
            game.winLoseFlag = false
            showFinish()
        }
    }
    
    
    //MARK: View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScene()
        setupGestureRecognizers()
        game.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureScene()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
    
    //Mark: UI Setup
    
    private func setupScene(){
        sceneView.delegate = self
        sceneView.scene = SCNScene()
        sceneView.scene.physicsWorld.contactDelegate = self
        sceneView.overlaySKScene = SKScene(size: sceneView.bounds.size)
        sceneView.overlaySKScene?.scaleMode = .resizeFill
        setupLabels()
        setupRadar()
    }
    
    private func configureScene(){
        let config = ARWorldTrackingConfiguration()
        sceneView.session.run(config)
    }
    
    private func setupGestureRecognizers(){
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(recognizer:)))
        let threeTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleThreeFingerTap(sender:)))
        let fourTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleFourFingerTap(sender:)))
        threeTapRecognizer.numberOfTouchesRequired = 3
        tapRecognizer.numberOfTouchesRequired = 1
        fourTapRecognizer.numberOfTouchesRequired = 4
        sceneView.addGestureRecognizer(tapRecognizer)
        sceneView.addGestureRecognizer(threeTapRecognizer)
        sceneView.addGestureRecognizer(fourTapRecognizer)
    }
    
    private func setupRadar(){
        let size = sceneView.bounds.size
        radarNode = SKShapeNode(circleOfRadius: 60)
        radarNode.position = CGPoint(x: size.width/2, y: (size.height - 80 - topPadding))
        radarNode.strokeColor = .blue
        radarNode.glowWidth = 5
        radarNode.fillColor = .gray
        radarNode.alpha = 0.7
        sceneView.overlaySKScene?.addChild(radarNode)
        norteNode = SKShapeNode(rectOf: CGSize(width: 2, height: 60))
        norteNode.fillColor = .brown
        norteNode.position.x = radarNode.position.x
        norteNode.position.y = radarNode.position.y + 30
        sceneView.overlaySKScene?.addChild(norteNode)
        for i in (1...4){
            let ringNode = SKShapeNode(circleOfRadius: CGFloat(i * 12))
            ringNode.strokeColor = .green
            ringNode.glowWidth = 0.2
            ringNode.name = "Ring"
            ringNode.position = radarNode.position
            sceneView.overlaySKScene?.addChild(ringNode)
        }
        for _ in (0..<(game.maxEnemigos)){
            let blip = SKShapeNode(circleOfRadius: 3)
            blip.fillColor = .red
            blip.strokeColor = .black
            blip.alpha = 1
            radarNode.addChild(blip)
        }
        
    }
    
    private func setupLabels(){
        let size = sceneView.bounds.size
        
        scoreNode = SKLabelNode(attributedText: NSAttributedString(string: "Puntos: \(game.score)", attributes: stringAttributes))
        livesNode = SKLabelNode(attributedText: NSAttributedString(string: "Vida: \(game.health)", attributes: stringAttributes))
        winNode = SKLabelNode(text: "Default")
        winNode.alpha = 0
        
        
        scoreNode.position = CGPoint(x: (size.width - scoreNode.frame.width/2) - sidePadding, y: (size.height - scoreNode.frame.height) - topPadding)
        livesNode.position = CGPoint(x: sidePadding + livesNode.frame.width/2, y: (size.height - livesNode.frame.height) - topPadding )
        winNode.position = CGPoint(x: size.width/2, y: size.height/2)
        
        sceneView.overlaySKScene?.addChild(scoreNode)
        sceneView.overlaySKScene?.addChild(livesNode)
        sceneView.overlaySKScene?.addChild(winNode)
    }
    
    private func showFinish(){
        guard let hasWon = game.winLoseFlag else { return }
        winNode.alpha = 1
        winNode.attributedText = NSAttributedString(string: hasWon ? "Has ganado!" : "Has perdido!", attributes: titleAttributes)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
            self.performSegue(withIdentifier: "unwind", sender: self)
        })
    }
    
    //Mark: UI Gesture Actions
    
    @objc func handleTap(recognizer: UITapGestureRecognizer){
        if game.playerCanShoot() {
            disparaProyectil(fromNode: sceneView.pointOfView!, type: .player)
        }
    }
    
    @objc func handleThreeFingerTap(sender: UITapGestureRecognizer){
        game.health += 20
    }
    
    @objc func handleFourFingerTap(sender: UITapGestureRecognizer){
        
        // sceneView.scene.rootNode.addChildNode(enemigoNode.node)
    }
    
    //MARK: Game Actions
    
    func disparaProyectil(fromNode node: SCNNode, type: TipoEnemigo){
        guard game.winLoseFlag == nil else { return }
        let pov = sceneView.pointOfView!
        var position: SCNVector3
        var convertedPosition: SCNVector3
        var direction : SCNVector3
        
        switch type {
            
        case .enemy:
            // Si es enemigo, dispara en dirección del jugador
            position = SCNVector3Make(0, 0, 0.05)
            convertedPosition = node.convertPosition(position, to: nil)
            direction = pov.position - node.position
        default:
            // Si es jugador dispara de frente
            position = SCNVector3Make(0, 0, -0.05)
            convertedPosition = node.convertPosition(position, to: nil)
            direction = convertedPosition - pov.position
        }
        
        let laser = ProyectilN(initialPosition: convertedPosition, direction: direction, type: type)
        proyectiles.append(laser)
        sceneView.scene.rootNode.addChildNode(laser.node)
    }
    
    private func apareceEnemigo(enemigo: Nivel){
        let pov = sceneView.pointOfView!
        let y = (Float(arc4random_uniform(60)) - 29) * 0.01 // Valor random de y entre -0.3 y 0.3
    
        // Valores X,Z aleatorios
        let xRad = ((Float(arc4random_uniform(361)) - 180)/180) * Float.pi
        let zRad = ((Float(arc4random_uniform(361)) - 180)/180) * Float.pi
        let length = Float(arc4random_uniform(6) + 4) * -0.3
        let x = length * sin(xRad)
        let z = length * cos(zRad)
        let position = SCNVector3Make(x, y, z)
        let worldPosition = pov.convertPosition(position, to: nil)
        let enemigoNode = EnemigoN(nivel: enemigo, position: worldPosition, cameraPosition: pov.position)
        
        enemigos.append(enemigoNode)
        sceneView.scene.rootNode.addChildNode(enemigoNode.node)
    }
    
}

//MARK: Scene Physics Contact Delegate

extension GameViewController : SCNPhysicsContactDelegate {
    
    func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
        let maskA = contact.nodeA.physicsBody!.contactTestBitMask
        let maskB = contact.nodeB.physicsBody!.contactTestBitMask
        
        switch(maskA, maskB){
        case (PhysicsMask.enemy, PhysicsMask.playerBullet):
            hitEnemy(bullet: contact.nodeB, enemy: contact.nodeA)
        case (PhysicsMask.playerBullet, PhysicsMask.enemy):
            hitEnemy(bullet: contact.nodeA, enemy: contact.nodeB)
        default:
            break
        }
    }
    // Suma un punto al acertar al enemigo
    func hitEnemy(bullet: SCNNode, enemy: SCNNode){
        bullet.removeFromParentNode()
        enemy.removeFromParentNode()
        game.score += 1
    }
}

//MARK: AR SceneView Delegate
extension GameViewController : ARSCNViewDelegate{
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        guard game.winLoseFlag == nil else { return }
        
        // tiene que retornar un enemigo y en caso de que no se pueda crear retorna nil
        
        if let enemigo = game.apareceEnemigo(numEnemigos: enemigos.count){
            apareceEnemigo(enemigo: enemigo)
        }
        
        for (i, enemigo) in enemigos.enumerated().reversed() {
            
            // Si el enemigo ya no está más en el world, se quita de la lista de enemigos
            guard enemigo.node.parent != nil else {
                enemigos.remove(at: i)
                continue
            }
    
            // Aproxima el enemigo a su objetivo
            if enemigo.move(towardsPosition: sceneView.pointOfView!.position) == false {
                // Si la funcion move devuelve falso, se asume que ha colisionado por lo que quitará al enemigo del world
                // si se choca el alien contra ti
                enemigo.node.removeFromParentNode()
                enemigos.remove(at: i)
                game.health -= enemigo.nivel.health
            }else {
                
                if enemigo.nivel.shouldShoot() {
                    disparaProyectil(fromNode: enemigo.node, type: .enemy)
                }
            }
        }
        
        // Dibuja los enemigos en el radar
        for (i, blip) in radarNode.children.enumerated() {
            if i < enemigos.count {
                let enemigo = enemigos[i]
                blip.alpha = 1
                // Coge la posicion del ene,igo recien aparecido en funcion de la nuestra
                let relativePosition = sceneView.pointOfView!.convertPosition(enemigo.node.position, from: nil)
                // Multiplica por 10 porque son valores muy pequeños
                var x = relativePosition.x * 12
                // Coge como y la z ya que pasa de 3D a 2D
                var y = relativePosition.z * -10
                if x >= 0 { x = min(x, 35) } else { x = max(x, -35)}
                if y >= 0 { y = min(y, 35) } else { y = max(y, -35)}
                blip.position = CGPoint(x: CGFloat(x), y: CGFloat(y))
            }else{
                blip.alpha = 0
            }
            
        }
        
        for (i, laser) in proyectiles.enumerated().reversed() {
            if laser.node.parent == nil {
                // Si el proyectil ya no está en el world, desaparece de la lista
                proyectiles.remove(at: i)
            }
            
            // mueve los proyectiles
            if laser.move() == false {//si es falso, remove
                laser.node.removeFromParentNode()
                proyectiles.remove(at: i)
            }else{
                // Comprueba si se choca contra el jugador
                if laser.node.physicsBody?.contactTestBitMask == PhysicsMask.enemyBullet
                    && laser.node.position.distance(vector: sceneView.pointOfView!.position) < 0.03{
                    laser.node.removeFromParentNode()
                    proyectiles.remove(at: i)
                    game.health -= 1
                }
            }
        }
    }
    
    
    func session(_ session: ARSession, cameraDidChangeTrackingState camera: ARCamera) {
        switch camera.trackingState {
        case .notAvailable:
            print("Camera Not Available")
        case .limited(let reason):
            switch reason {
            case .excessiveMotion:
                print("Camera Tracking State Limited Due to Excessive Motion")
            case .initializing:
                print("Camera Tracking State Limited Due to Initalization")
            case .insufficientFeatures:
                print("Camera Tracking State Limited Due to Insufficient Features")
            case .relocalizing:
                print("Camera Tracking State Limited Due to Relocalizing")
            }
        case .normal:
            print("Camera Tracking State Normal")
        }
    }
    func session(_ session: ARSession, didFailWithError error: Error) {
        print("Session Failed with error: \(error.localizedDescription)")
        // Presenta un error al usuario
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        print("Session Interrupted")
    
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        print("Session no longer being interrupted")
        
    }
    
}
