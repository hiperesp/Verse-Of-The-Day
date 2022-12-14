
import ScreenSaver
import SpriteKit

class VOTDMainView: ScreenSaverView {
    
    private let wordsDefinition: [WordDefinition] = WordDefinition.createWordsDefinitionList()
    
    private var view: SKView?
    private var scene: SKScene?
    private var random: SeedRandom?
    
    override init?(frame: NSRect, isPreview: Bool) {
        super.init(frame: frame, isPreview: isPreview)
        self.initRandom()
    }

    @available(*, unavailable)
    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initRandom() -> Void {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd"

        self.random = SeedRandom(seed: dateFormatter.string(from: Date()))
    }
    
    private func draw() {
        drawBackground()
        drawMainMessage()
    }
    
    private func drawMainMessage() {
        let visibleDuration: CGFloat = 15
        
        let cWord: WordDefinition = wordsDefinition.randomElement(using: &self.random!)!
        
        let label: SKLabelNode = SKLabelNode(text: cWord.word)
        let definition: SKLabelNode = SKLabelNode(text: cWord.definition)
        
        let waitBeforeStart: SKAction = SKAction.wait(forDuration: 5)

        if true {
            label.fontColor = .white
            label.fontName = "Arial Rounded MT Bold"
            label.fontSize = frame.size.height * 0.075
            label.alpha = 0
            label.horizontalAlignmentMode = .left
            label.position.x = frame.size.width + label.frame.width / 2
            label.position.y = (frame.size.height - label.frame.height) * 0.6 + label.frame.height / 2
            scene?.addChild(label)
            
            // INICIO
            let moveInAction: SKAction = SKAction.moveTo(x: 50, duration: 5)
            moveInAction.timingMode = SKActionTimingMode.easeOut
            let fadeInAction: SKAction = SKAction.fadeAlpha(to: 0.9, duration: 5)
            fadeInAction.timingMode = SKActionTimingMode.easeIn
            // MEIO
            let waitAction: SKAction = SKAction.wait(forDuration: TimeInterval(visibleDuration))
            // FIM
            let fadeOutAction: SKAction = SKAction.fadeAlpha(to: 0, duration:2)
            fadeOutAction.timingMode = SKActionTimingMode.easeIn
            let moveOutAction: SKAction = SKAction.moveTo(x: 0 - label.frame.width, duration: 2)
            moveOutAction.timingMode = SKActionTimingMode.easeIn
            //EXECUCAO
            label.run(SKAction.sequence([
                SKAction.group([waitBeforeStart]),
                SKAction.group([moveInAction, fadeInAction]),
                SKAction.group([waitAction]),
                SKAction.group([moveOutAction, fadeOutAction])
            ])) {
                label.removeFromParent()
                self.draw()
            }
        }
        
        if true {
            definition.fontColor = .white
            definition.fontName = "Arial Rounded MT"
            definition.fontSize = frame.size.height * 0.05
            definition.alpha = 0
            definition.position.x = 50
            definition.position.y = label.position.y
            definition.lineBreakMode = .byWordWrapping
            definition.numberOfLines = 10
            definition.horizontalAlignmentMode = .left
            definition.verticalAlignmentMode = .top
            definition.preferredMaxLayoutWidth = frame.width - 100
            scene?.addChild(definition)
            
            // INICIO
            let waitAction: SKAction = SKAction.wait(forDuration: TimeInterval(5))
            // MEIO
            let moveInAction: SKAction = SKAction.moveTo(y: definition.position.y - label.frame.height * 1.1, duration: 0.5)
            moveInAction.timingMode = SKActionTimingMode.easeOut
            let fadeInAction: SKAction = SKAction.fadeAlpha(to: 0.8, duration: 1)
            fadeInAction.timingMode = SKActionTimingMode.easeOut
            let wait2Action: SKAction = SKAction.wait(forDuration: TimeInterval(visibleDuration - 1))
            // FIM
            let fadeOutAction: SKAction = SKAction.fadeAlpha(to: 0, duration: 2)
            fadeOutAction.timingMode = SKActionTimingMode.easeIn
            let moveOutAction: SKAction = SKAction.moveTo(x: 0 - label.frame.width, duration: 2)
            moveOutAction.timingMode = SKActionTimingMode.easeIn
            //EXECUCAO
            definition.run(SKAction.sequence([
                SKAction.group([waitBeforeStart]),
                SKAction.group([waitAction]),
                SKAction.group([moveInAction, fadeInAction]),
                SKAction.group([wait2Action]),
                SKAction.group([moveOutAction, fadeOutAction])
            ])) {
                definition.removeFromParent()
            }
        }
    }

    private func drawBackground() {
        for _ in 0...2 {
            let cWord: BackgroundWordAtScreen = BackgroundWordAtScreen.init(
                word: wordsDefinition.randomElement()!.word
            );
            
            let text: String = "\(cWord.word)"
            
            let label: SKLabelNode = SKLabelNode(text: text)
            label.fontColor = .white
            label.fontName = "Arial Rounded MT Bold"
            label.fontSize = frame.size.height * cWord.size.sizeMult
            label.zPosition = CGFloat(cWord.size.zPosition)
            label.alpha = 0
            label.position.x = frame.size.width + label.frame.width / 2
            label.position.y = (frame.size.height - label.frame.height) * cWord.position.yPositionMult + label.frame.height / 2
            scene?.addChild(label)

            let duration = TimeInterval(max(cWord.size.durationMin, Int(frame.size.width * cWord.size.durationMult)));

            //INICIO
            let moveAction: SKAction = SKAction.moveTo(x: 0 - (label.frame.width / 2), duration: duration)
            moveAction.timingMode = SKActionTimingMode.easeIn
            let fadeInAction: SKAction = SKAction.fadeAlpha(to: cWord.size.maxAlpha, duration: duration)
            fadeInAction.timingMode = SKActionTimingMode.easeIn
            //FIM
            let fadeOutAction = SKAction.fadeAlpha(to: 0, duration: 2)

            label.run(SKAction.group([
                moveAction,
                SKAction.sequence([fadeInAction, fadeOutAction])
            ])) {
                label.removeFromParent()
            }
        }
    }
    
    let backgroundColors: [SKColor] = [
        .init(red: 0.5, green: 0.75, blue: 1, alpha: 1),
        .init(red: 0.75, green: 1, blue: 0.5, alpha: 1),
        .init(red: 1, green: 0.5, blue: 0.75, alpha: 1),
    ]
    var backgroundColorsIndex = 0
    var background: SKSpriteNode?
    func runBackground() {
        self.backgroundColorsIndex += 1
        if(self.backgroundColorsIndex >= self.backgroundColors.count) {
            self.backgroundColorsIndex = 0
        }
        let action: SKAction = SKAction.colorize(with: self.backgroundColors[self.backgroundColorsIndex], colorBlendFactor: 1, duration: 60)
        background!.run(action) {
            self.runBackground()
        }
    }
    
    override func startAnimation() {
        view = SKView(frame: frame)
        view?.ignoresSiblingOrder = true
        view?.preferredFramesPerSecond = 60
        view?.allowsTransparency = true
        scene = SKScene(size: frame.size)
        addSubview(view!)
        view?.presentScene(scene)

        background = SKSpriteNode(color: self.backgroundColors[self.backgroundColorsIndex], size: frame.size)
        background?.position = CGPoint(x: frame.size.width/2, y: frame.size.height/2)
        background?.zPosition = -99
        scene?.addChild(background!)
        

//        view?.showsFPS = true
//        view?.showsNodeCount = true

        runBackground()
        draw()
    }
}

class WordDefinition {
    var word: String = ""
    var definition: String = ""
    
    init(word: String, definition: String) {
        self.word = word
        self.definition = definition
    }
    
    static func createWordsDefinitionList() -> [WordDefinition] {
        return [
            WordDefinition(word: "Romanos 10:9",        definition: "A saber: Se, com a tua boca, confessares ao Senhor Jesus e, em teu cora????o, creres que Deus o ressuscitou dos mortos, ser??s salvo."),
            WordDefinition(word: "1 Pedro 3:15",        definition: "Antes, santificai a Cristo, como Senhor, em vosso cora????o; e estai sempre preparados para responder com mansid??o e temor a qualquer que vos pedir a raz??o da esperan??a que h?? em v??s."),
            WordDefinition(word: "2 Cor??ntios 5:21",    definition: "??quele que n??o conheceu pecado, o fez pecado por n??s; para que, nele, f??ssemos feitos justi??a de Deus."),
            WordDefinition(word: "2 Cor??ntios 5:17",    definition: "Assim que, se algu??m est?? em Cristo, nova criatura ??: as coisas velhas j?? passaram; eis que tudo se fez novo."),
            WordDefinition(word: "Mateus 5:16",         definition: "Assim resplande??a a vossa luz diante dos homens, para que vejam as vossas boas obras e glorifiquem o vosso Pai, que est?? nos c??us."),
            WordDefinition(word: "Tiago 1:12",          definition: "Bem-aventurado o var??o que sofre a tenta????o; porque, quando for provado, receber?? a coroa da vida, a qual o Senhor tem prometido aos que o amam."),
            WordDefinition(word: "Hebreus 4:16",        definition: "Cheguemos, pois, com confian??a ao trono da gra??a, para que possamos alcan??ar miseric??rdia e achar gra??a, a fim de sermos ajudados em tempo oportuno."),
            WordDefinition(word: "Salmos 133:3",        definition: "Como o orvalho do Hermom, que desce sobre os montes de Si??o; porque ali o Senhor ordena a b??n????o e a vida para sempre."),
            WordDefinition(word: "Tiago 5:16",          definition: "Confessai as vossas culpas uns aos outros e orai uns pelos outros, para que sareis; a ora????o feita por um justo pode muito em seus efeitos."),
            WordDefinition(word: "Prov??rbios 3:5",      definition: "Confia no Senhor de todo o teu cora????o e n??o te estribes no teu pr??prio entendimento."),
            WordDefinition(word: "1 Jo??o 3:16",         definition: "Conhecemos o amor nisto: que ele deu a sua vida por n??s, e n??s devemos dar a vida pelos irm??os."),
            WordDefinition(word: "G??latas 5:23",        definition: "Contra essas coisas n??o h?? lei."),
            WordDefinition(word: "Romanos 10:17",       definition: "De sorte que a f?? ?? pelo ouvir, e o ouvir pela palavra de Deus."),
            WordDefinition(word: "Jo??o 14:27",          definition: "Deixo-vos a paz, a minha paz vos dou; n??o vo-la dou como o mundo a d??. N??o se turbe o vosso cora????o, nem se atemorize."),
            WordDefinition(word: "Salmos 37:4",         definition: "Deleita-te tamb??m no Senhor, e ele te conceder?? o que deseja o teu cora????o."),
            WordDefinition(word: "Jo??o 11:25",          definition: "Disse-lhe Jesus: Eu sou a ressurrei????o e a vida; quem cr?? em mim, ainda que esteja morto, viver??."),
            WordDefinition(word: "Jo??o 14:6",           definition: "Disse-lhe Jesus: Eu sou o caminho, e a verdade, e a vida. Ningu??m vem ao Pai sen??o por mim."),
            WordDefinition(word: "Filipenses 4:7",      definition: "E a paz de Deus, que excede todo o entendimento, guardar?? os vossos cora????es e os vossos sentimentos em Cristo Jesus."),
            WordDefinition(word: "Salmos 133:2",        definition: "?? como o ??leo precioso sobre a cabe??a, que desce sobre a barba, a barba de Ar??o, e que desce ?? orla das suas vestes."),
            WordDefinition(word: "G??nesis 1:27",        definition: "E criou Deus o homem ?? sua imagem; ?? imagem de Deus o criou; macho e f??mea os criou."),
            WordDefinition(word: "G??nesis 1:26",        definition: "E disse Deus: Fa??amos o homem ?? nossa imagem, conforme a nossa semelhan??a; e domine sobre os peixes do mar, e sobre as aves dos c??us, e sobre o gado, e sobre toda a terra, e sobre todo r??ptil que se move sobre a terra."),
            WordDefinition(word: "Atos 18:9",           definition: "E disse o Senhor, em vis??o, a Paulo: N??o temas, mas fala e n??o te cales."),
            WordDefinition(word: "Atos 2:38",           definition: "E disse-lhes Pedro: Arrependei-vos, e cada um de v??s seja batizado em nome de Jesus Cristo para perd??o dos pecados, e recebereis o dom do Esp??rito Santo."),
            WordDefinition(word: "2 Cor??ntios 12:9",    definition: "E disse-me: A minha gra??a te basta, porque o meu poder se aperfei??oa na fraqueza. De boa vontade, pois, me gloriarei nas minhas fraquezas, para que em mim habite o poder de Cristo."),
            WordDefinition(word: "Atos 4:12",           definition: "E em nenhum outro h?? salva????o, porque tamb??m debaixo do c??u nenhum outro nome h??, dado entre os homens, pelo qual devamos ser salvos."),
            WordDefinition(word: "Atos 18:11",          definition: "E ficou ali um ano e seis meses, ensinando entre eles a palavra de Deus."),
            WordDefinition(word: "Mateus 22:37",        definition: "E Jesus disse-lhe: Amar??s o Senhor, teu Deus, de todo o teu cora????o, e de toda a tua alma, e de todo o teu pensamento."),
            WordDefinition(word: "Romanos 12:2",        definition: "E n??o vos conformeis com este mundo, mas transformai-vos pela renova????o do vosso entendimento, para que experimenteis qual seja a boa, agrad??vel e perfeita vontade de Deus."),
            WordDefinition(word: "Romanos 8:28",        definition: "E sabemos que todas as coisas contribuem juntamente para o bem daqueles que amam a Deus, daqueles que s??o chamados por seu decreto."),
            WordDefinition(word: "Mateus 28:18",        definition: "E, chegando-se Jesus, falou-lhes, dizendo: ??-me dado todo o poder no c??u e na terra."),
            WordDefinition(word: "Colossenses 3:23",    definition: "E, tudo quanto fizerdes, fazei-o de todo o cora????o, como ao Senhor e n??o aos homens."),
            WordDefinition(word: "Miqu??ias 6:8",        definition: "Ele te declarou, ?? homem, o que ?? bom; e que ?? o que o Senhor pede de ti, sen??o que pratiques a justi??a, e ames a benefic??ncia, e andes humildemente com o teu Deus?"),
            WordDefinition(word: "Mateus 28:20",        definition: "Ensinando-as a guardar todas as coisas que eu vos tenho mandado; e eis que eu estou convosco todos os dias, at?? ?? consuma????o dos s??culos. Am??m!"),
            WordDefinition(word: "G??latas 2:20",        definition: "J?? estou crucificado com Cristo; e vivo, n??o mais eu, mas Cristo vive em mim; e a vida que agora vivo na carne vivo-a na f?? do Filho de Deus, o qual me amou e se entregou a si mesmo por mim."),
            WordDefinition(word: "1 Pedro 5:7",         definition: "Lan??ando sobre ele toda a vossa ansiedade, porque ele tem cuidado de v??s."),
            WordDefinition(word: "1 Pedro 2:24",        definition: "Levando ele mesmo em seu corpo os nossos pecados sobre o madeiro, para que, mortos para os pecados, pud??ssemos viver para a justi??a; e pelas suas feridas fostes sarados."),
            WordDefinition(word: "Jo??o 1:12",           definition: "Mas a todos quantos o receberam deu-lhes o poder de serem feitos filhos de Deus: aos que creem no seu nome"),
            WordDefinition(word: "Mateus 6:33",         definition: "Mas buscai primeiro o Reino de Deus, e a sua justi??a, e todas essas coisas vos ser??o acrescentadas."),
            WordDefinition(word: "Romanos 5:8",         definition: "Mas Deus prova o seu amor para conosco em que Cristo morreu por n??s, sendo n??s ainda pecadores."),
            WordDefinition(word: "Isa??as 53:5",         definition: "Mas ele foi ferido pelas nossas transgress??es e mo??do pelas nossas iniquidades; o castigo que nos traz a paz estava sobre ele, e, pelas suas pisaduras, fomos sarados."),
            WordDefinition(word: "G??latas 5:22",        definition: "Mas o fruto do Esp??rito ??: amor, gozo, paz, longanimidade, benignidade, bondade, f??, mansid??o, temperan??a."),
            WordDefinition(word: "Isa??as 40:31",        definition: "Mas os que esperam no Senhor renovar??o as suas for??as e subir??o com asas como ??guias; correr??o e n??o se cansar??o; caminhar??o e n??o se fatigar??o."),
            WordDefinition(word: "Atos 1:8",            definition: "Mas recebereis a virtude do Esp??rito Santo, que h?? de vir sobre v??s; e ser-me-eis testemunhas tanto em Jerusal??m como em toda a Judeia e Samaria e at?? aos confins da terra."),
            WordDefinition(word: "Tiago 1:2",           definition: "Meus irm??os, tende grande gozo quando cairdes em v??rias tenta????es"),
            WordDefinition(word: "Jo??o 5:24",           definition: "Na verdade, na verdade vos digo que quem ouve a minha palavra e cr?? naquele que me enviou tem a vida eterna e n??o entrar?? em condena????o, mas passou da morte para a vida."),
            WordDefinition(word: "Hebreus 10:25",       definition: "N??o deixando a nossa congrega????o, como ?? costume de alguns; antes, admoestando-nos uns aos outros; e tanto mais quanto vedes que se vai aproximando aquele Dia."),
            WordDefinition(word: "Filipenses 4:6",      definition: "N??o estejais inquietos por coisa alguma; antes, as vossas peti????es sejam em tudo conhecidas diante de Deus, pela ora????o e s??plicas, com a????o de gra??as."),
            WordDefinition(word: "Josu?? 1:8",           definition: "N??o se aparte da tua boca o livro desta Lei; antes, medita nele dia e noite, para que tenhas cuidado de fazer conforme tudo quanto nele est?? escrito; porque, ent??o, far??s prosperar o teu caminho e, ent??o, prudentemente te conduzir??s."),
            WordDefinition(word: "Isa??as 41:10",        definition: "N??o temas, porque eu sou contigo; n??o te assombres, porque eu sou o teu Deus; eu te esfor??o, e te ajudo, e te sustento com a destra da minha justi??a."),
            WordDefinition(word: "Josu?? 1:9",           definition: "N??o to mandei eu? Esfor??a-te e tem bom ??nimo; n??o pasmes, nem te espantes, porque o Senhor, teu Deus, ?? contigo, por onde quer que andares."),
            WordDefinition(word: "1 Cor??ntios 10:13",   definition: "N??o veio sobre v??s tenta????o, sen??o humana; mas fiel ?? Deus, que vos n??o deixar?? tentar acima do que podeis; antes, com a tenta????o dar?? tamb??m o escape, para que a possais suportar."),
            WordDefinition(word: "Ef??sios 2:9",         definition: "N??o vem das obras, para que ningu??m se glorie."),
            WordDefinition(word: "Romanos 8:39",        definition: "Nem a altura, nem a profundidade, nem alguma outra criatura nos poder?? separar do amor de Deus, que est?? em Cristo Jesus, nosso Senhor!"),
            WordDefinition(word: "Jo??o 15:13",          definition: "Ningu??m tem maior amor do que este: de dar algu??m a sua vida pelos seus amigos."),
            WordDefinition(word: "Jo??o 13:35",          definition: "Nisto todos conhecer??o que sois meus disc??pulos, se vos amardes uns aos outros."),
            WordDefinition(word: "G??nesis 1:1",         definition: "No princ??pio, criou Deus os c??us e a terra."),
            WordDefinition(word: "Jo??o 1:1",            definition: "No princ??pio, era o Verbo, e o Verbo estava com Deus, e o Verbo era Deus."),
            WordDefinition(word: "Jo??o 10:10",          definition: "O ladr??o n??o vem sen??o a roubar, a matar e a destruir; eu vim para que tenham vida e a tenham com abund??ncia."),
            WordDefinition(word: "Filipenses 4:19",     definition: "O meu Deus, segundo as suas riquezas, suprir?? todas as vossas necessidades em gl??ria, por Cristo Jesus."),
            WordDefinition(word: "Salmos 133:1",        definition: "Oh! Qu??o bom e qu??o suave ?? que os irm??os vivam em uni??o!"),
            WordDefinition(word: "Hebreus 12:2",        definition: "Olhando para Jesus, autor e consumador da f??, o qual, pelo gozo que lhe estava proposto, suportou a cruz, desprezando a afronta, e assentou-se ?? destra do trono de Deus."),
            WordDefinition(word: "Hebreus 11:1",        definition: "Ora, a f?? ?? o firme fundamento das coisas que se esperam e a prova das coisas que se n??o veem."),
            WordDefinition(word: "Ef??sios 3:20",        definition: "Ora, ??quele que ?? poderoso para fazer tudo muito mais abundantemente al??m daquilo que pedimos ou pensamos, segundo o poder que em n??s opera."),
            WordDefinition(word: "Atos 17:11",          definition: "Ora, estes foram mais nobres do que os que estavam em Tessal??nica, porque de bom grado receberam a palavra, examinando cada dia nas Escrituras se estas coisas eram assim."),
            WordDefinition(word: "Romanos 15:13",       definition: "Ora, o Deus de esperan??a vos encha de todo o gozo e paz em cren??a, para que abundeis em esperan??a pela virtude do Esp??rito Santo."),
            WordDefinition(word: "Hebreus 11:6",        definition: "Ora, sem f?? ?? imposs??vel agradar-lhe, porque ?? necess??rio que aquele que se aproxima de Deus creia que ele existe e que ?? galardoador dos que o buscam."),
            WordDefinition(word: "1 Cor??ntios 6:19",    definition: "Ou n??o sabeis que o nosso corpo ?? o templo do Esp??rito Santo, que habita em v??s, proveniente de Deus, e que n??o sois de v??s mesmos?"),
            WordDefinition(word: "2 Pedro 1:4",         definition: "Pelas quais ele nos tem dado grand??ssimas e preciosas promessas, para que por elas fiqueis participantes da natureza divina, havendo escapado da corrup????o, que, pela concupisc??ncia, h?? no mundo"),
            WordDefinition(word: "Hebreus 4:12",        definition: "Porque a palavra de Deus ?? viva, e eficaz, e mais penetrante do que qualquer espada de dois gumes, e penetra at?? ?? divis??o da alma, e do esp??rito, e das juntas e medulas, e ?? apta para discernir os pensamentos e inten????es do cora????o."),
            WordDefinition(word: "Jo??o 3:16",           definition: "Porque Deus amou o mundo de tal maneira que deu o seu Filho unig??nito, para que todo aquele que nele cr?? n??o pere??a, mas tenha a vida eterna."),
            WordDefinition(word: "Jo??o 3:17",           definition: "Porque Deus enviou o seu Filho ao mundo n??o para que condenasse o mundo, mas para que o mundo fosse salvo por ele."),
            WordDefinition(word: "2 Tim??teo 1:7",       definition: "Porque Deus n??o nos deu o esp??rito de temor, mas de fortaleza, e de amor, e de modera????o."),
            WordDefinition(word: "Romanos 8:38",        definition: "Porque estou certo de que nem a morte, nem a vida, nem os anjos, nem os principados, nem as potestades, nem o presente, nem o porvir."),
            WordDefinition(word: "Jeremias 29:11",      definition: "Porque eu bem sei os pensamentos que penso de v??s, diz o Senhor; pensamentos de paz e n??o de mal, para vos dar o fim que esperais."),
            WordDefinition(word: "Atos 18:10",          definition: "Porque eu sou contigo, e ningu??m lan??ar?? m??o de ti para te fazer mal, pois tenho muito povo nesta cidade."),
            WordDefinition(word: "Hebreus 4:15",        definition: "Porque n??o temos um sumo sacerdote que n??o possa compadecer-se das nossas fraquezas; por??m um que, como n??s, em tudo foi tentado, mas sem pecado."),
            WordDefinition(word: "Mateus 11:30",        definition: "Porque o meu jugo ?? suave, e o meu fardo ?? leve."),
            WordDefinition(word: "Romanos 6:23",        definition: "Porque o sal??rio do pecado ?? a morte, mas o dom gratuito de Deus ?? a vida eterna, por Cristo Jesus, nosso Senhor."),
            WordDefinition(word: "Isa??as 55:8",         definition: "Porque os meus pensamentos n??o s??o os vossos pensamentos, nem os vossos caminhos, os meus caminhos, diz o Senhor."),
            WordDefinition(word: "Ef??sios 2:8",         definition: "Porque pela gra??a sois salvos, por meio da f??; e isso n??o vem de v??s; ?? dom de Deus."),
            WordDefinition(word: "Ef??sios 2:10",        definition: "Porque somos feitura sua, criados em Cristo Jesus para as boas obras, as quais Deus preparou para que and??ssemos nelas."),
            WordDefinition(word: "Romanos 3:23",        definition: "Porque todos pecaram e destitu??dos est??o da gl??ria de Deus."),
            WordDefinition(word: "Mateus 28:19",        definition: "Portanto, ide, ensinai todas as na????es, batizando-as em nome do Pai, e do Filho, e do Esp??rito Santo."),
            WordDefinition(word: "Hebreus 12:1",        definition: "Portanto, n??s tamb??m, pois, que estamos rodeados de uma t??o grande nuvem de testemunhas, deixemos todo embara??o e o pecado que t??o de perto nos rodeia e corramos, com paci??ncia, a carreira que nos est?? proposta."),
            WordDefinition(word: "Filipenses 4:13",     definition: "Posso todas as coisas naquele que me fortalece."),
            WordDefinition(word: "Filipenses 4:8",      definition: "Quanto ao mais, irm??os, tudo o que ?? verdadeiro, tudo o que ?? honesto, tudo o que ?? justo, tudo o que ?? puro, tudo o que ?? am??vel, tudo o que ?? de boa fama, se h?? alguma virtude, e se h?? algum louvor, nisso pensai."),
            WordDefinition(word: "Prov??rbios 3:6",      definition: "Reconhece-o em todos os teus caminhos, e ele endireitar?? as tuas veredas."),
            WordDefinition(word: "Colossenses 3:12",    definition: "Revesti-vos, pois, como eleitos de Deus, santos e amados, de entranhas de miseric??rdia, de benignidade, humildade, mansid??o, longanimidade"),
            WordDefinition(word: "Romanos 12:1",        definition: "Rogo-vos, pois, irm??os, pela compaix??o de Deus, que apresenteis o vosso corpo em sacrif??cio vivo, santo e agrad??vel a Deus, que ?? o vosso culto racional."),
            WordDefinition(word: "Tiago 1:3",           definition: "Sabendo que a prova da vossa f?? produz a paci??ncia."),
            WordDefinition(word: "1 Jo??o 1:9",          definition: "Se confessarmos os nossos pecados, ele ?? fiel e justo para nos perdoar os pecados e nos purificar de toda injusti??a."),
            WordDefinition(word: "Hebreus 13:5",        definition: "Sejam vossos costumes sem avareza, contentando-vos com o que tendes; porque ele disse: N??o te deixarei, nem te desampararei."),
            WordDefinition(word: "Filipenses 1:6",      definition: "Tendo por certo isto mesmo: que aquele que em v??s come??ou a boa obra a aperfei??oar?? at?? ao Dia de Jesus Cristo."),
            WordDefinition(word: "Jo??o 16:33",          definition: "Tenho-vos dito isso, para que em mim tenhais paz; no mundo tereis afli????es, mas tende bom ??nimo; eu venci o mundo."),
            WordDefinition(word: "2 Tim??teo 3:16",      definition: "Toda Escritura divinamente inspirada ?? proveitosa para ensinar, para redarguir, para corrigir, para instruir em justi??a."),
            WordDefinition(word: "Isa??as 53:6",         definition: "Todos n??s andamos desgarrados como ovelhas; cada um se desviava pelo seu caminho, mas o Senhor fez cair sobre ele a iniquidade de n??s todos."),
            WordDefinition(word: "Mateus 11:29",        definition: "Tomai sobre v??s o meu jugo, e aprendei de mim, que sou manso e humilde de cora????o, e encontrareis descanso para a vossa alma."),
            WordDefinition(word: "Isa??as 26:3",         definition: "Tu conservar??s em paz aquele cuja mente est?? firme em ti; porque ele confia em ti."),
            WordDefinition(word: "Isa??as 53:4",         definition: "Verdadeiramente, ele tomou sobre si as nossas enfermidades e as nossas dores levou sobre si; e n??s o reputamos por aflito, ferido de Deus e oprimido."),
            WordDefinition(word: "Mateus 11:28",        definition: "Vinde a mim, todos os que estais cansados e oprimidos, e eu vos aliviarei.")
        ]
    }
}

class BackgroundWordAtScreen {
    
    let word: String
    let position: Position
    let size: Size
    
    enum Size: CaseIterable {
        case small
        case medium
        case large
        
        var sizeMult: CGFloat {
            switch self {
            case .small:
                return 1/8
            case .medium:
                return 1/6
            case .large:
                return 1/4
            }
        }
        var durationMin: Int {
            switch self {
            case .small:
                return 6
            case .medium:
                return 5
            case .large:
                return 4
            }
        }
        var durationMult: CGFloat {
            switch self {
            case .small:
                return 1/180
            case .medium:
                return 1/200
            case .large:
                return 1/240
            }
        }
        var maxAlpha: CGFloat {
            switch self {
            case .small:
                return 0.2
            case .medium:
                return 0.3
            case .large:
                return 0.5
            }
        }
        var zPosition: Int {
            switch self {
            case .small:
                return -3
            case .medium:
                return -2
            case .large:
                return -1
            }
        }
    }
    enum Position: CaseIterable {
        case top
        case middleTop
        case middle
        case midleBottom
        case bottom
        
        var yPositionMult: CGFloat {
            switch self {
            case .top:
                return 4/4
            case .middleTop:
                return 3/4
            case .middle:
                return 2/4
            case .midleBottom:
                return 1/4
            case .bottom:
                return 0/4
            }
        }
    }
    
    init(word: String) {
        self.word = word
        self.size = BackgroundWordAtScreen.getSize()
        self.position = BackgroundWordAtScreen.getPosition()
    }
    
    private static var _currentSizeIndex: Int = -1
    private static var _shuffledSizes: [Size] = []
    private static func getSize() -> Size {
        _currentSizeIndex += 1
        if _currentSizeIndex >= _shuffledSizes.count - 1 {
            _shuffledSizes = Size.allCases.shuffled()
            _currentSizeIndex = 0
        }
        return _shuffledSizes[_currentSizeIndex]
    }
    
    private static var _currentPositionIndex: Int = -1
    private static var _shuffledPositions: [Position] = []
    private static func getPosition() -> Position {
        _currentPositionIndex += 1
        if _currentPositionIndex >= _shuffledPositions.count - 1 {
            _shuffledPositions = Position.allCases.shuffled()
            _currentPositionIndex = 0
        }
        return _shuffledPositions[_currentPositionIndex]
    }
    
}

class SeedRandom: RandomNumberGenerator {
    
    let range: ClosedRange<Double> = Double(UInt64.min) ... Double(UInt64.max)

    init(seed: Int) {
        srand48(seed)
    }
    convenience init(seed: String) {
        var val: Int = 0;
        for char in seed {
            val += Int(char.asciiValue!)
        }
        self.init(seed: val);
    }
    
    func next() -> UInt64 {
        return UInt64(range.lowerBound + (range.upperBound - range.lowerBound) * drand48())
    }
}
