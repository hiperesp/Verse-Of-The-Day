
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
            WordDefinition(word: "Romanos 10:9",        definition: "A saber: Se, com a tua boca, confessares ao Senhor Jesus e, em teu coração, creres que Deus o ressuscitou dos mortos, serás salvo."),
            WordDefinition(word: "1 Pedro 3:15",        definition: "Antes, santificai a Cristo, como Senhor, em vosso coração; e estai sempre preparados para responder com mansidão e temor a qualquer que vos pedir a razão da esperança que há em vós."),
            WordDefinition(word: "2 Coríntios 5:21",    definition: "Àquele que não conheceu pecado, o fez pecado por nós; para que, nele, fôssemos feitos justiça de Deus."),
            WordDefinition(word: "2 Coríntios 5:17",    definition: "Assim que, se alguém está em Cristo, nova criatura é: as coisas velhas já passaram; eis que tudo se fez novo."),
            WordDefinition(word: "Mateus 5:16",         definition: "Assim resplandeça a vossa luz diante dos homens, para que vejam as vossas boas obras e glorifiquem o vosso Pai, que está nos céus."),
            WordDefinition(word: "Tiago 1:12",          definition: "Bem-aventurado o varão que sofre a tentação; porque, quando for provado, receberá a coroa da vida, a qual o Senhor tem prometido aos que o amam."),
            WordDefinition(word: "Hebreus 4:16",        definition: "Cheguemos, pois, com confiança ao trono da graça, para que possamos alcançar misericórdia e achar graça, a fim de sermos ajudados em tempo oportuno."),
            WordDefinition(word: "Salmos 133:3",        definition: "Como o orvalho do Hermom, que desce sobre os montes de Sião; porque ali o Senhor ordena a bênção e a vida para sempre."),
            WordDefinition(word: "Tiago 5:16",          definition: "Confessai as vossas culpas uns aos outros e orai uns pelos outros, para que sareis; a oração feita por um justo pode muito em seus efeitos."),
            WordDefinition(word: "Provérbios 3:5",      definition: "Confia no Senhor de todo o teu coração e não te estribes no teu próprio entendimento."),
            WordDefinition(word: "1 João 3:16",         definition: "Conhecemos o amor nisto: que ele deu a sua vida por nós, e nós devemos dar a vida pelos irmãos."),
            WordDefinition(word: "Gálatas 5:23",        definition: "Contra essas coisas não há lei."),
            WordDefinition(word: "Romanos 10:17",       definition: "De sorte que a fé é pelo ouvir, e o ouvir pela palavra de Deus."),
            WordDefinition(word: "João 14:27",          definition: "Deixo-vos a paz, a minha paz vos dou; não vo-la dou como o mundo a dá. Não se turbe o vosso coração, nem se atemorize."),
            WordDefinition(word: "Salmos 37:4",         definition: "Deleita-te também no Senhor, e ele te concederá o que deseja o teu coração."),
            WordDefinition(word: "João 11:25",          definition: "Disse-lhe Jesus: Eu sou a ressurreição e a vida; quem crê em mim, ainda que esteja morto, viverá."),
            WordDefinition(word: "João 14:6",           definition: "Disse-lhe Jesus: Eu sou o caminho, e a verdade, e a vida. Ninguém vem ao Pai senão por mim."),
            WordDefinition(word: "Filipenses 4:7",      definition: "E a paz de Deus, que excede todo o entendimento, guardará os vossos corações e os vossos sentimentos em Cristo Jesus."),
            WordDefinition(word: "Salmos 133:2",        definition: "É como o óleo precioso sobre a cabeça, que desce sobre a barba, a barba de Arão, e que desce à orla das suas vestes."),
            WordDefinition(word: "Gênesis 1:27",        definition: "E criou Deus o homem à sua imagem; à imagem de Deus o criou; macho e fêmea os criou."),
            WordDefinition(word: "Gênesis 1:26",        definition: "E disse Deus: Façamos o homem à nossa imagem, conforme a nossa semelhança; e domine sobre os peixes do mar, e sobre as aves dos céus, e sobre o gado, e sobre toda a terra, e sobre todo réptil que se move sobre a terra."),
            WordDefinition(word: "Atos 18:9",           definition: "E disse o Senhor, em visão, a Paulo: Não temas, mas fala e não te cales."),
            WordDefinition(word: "Atos 2:38",           definition: "E disse-lhes Pedro: Arrependei-vos, e cada um de vós seja batizado em nome de Jesus Cristo para perdão dos pecados, e recebereis o dom do Espírito Santo."),
            WordDefinition(word: "2 Coríntios 12:9",    definition: "E disse-me: A minha graça te basta, porque o meu poder se aperfeiçoa na fraqueza. De boa vontade, pois, me gloriarei nas minhas fraquezas, para que em mim habite o poder de Cristo."),
            WordDefinition(word: "Atos 4:12",           definition: "E em nenhum outro há salvação, porque também debaixo do céu nenhum outro nome há, dado entre os homens, pelo qual devamos ser salvos."),
            WordDefinition(word: "Atos 18:11",          definition: "E ficou ali um ano e seis meses, ensinando entre eles a palavra de Deus."),
            WordDefinition(word: "Mateus 22:37",        definition: "E Jesus disse-lhe: Amarás o Senhor, teu Deus, de todo o teu coração, e de toda a tua alma, e de todo o teu pensamento."),
            WordDefinition(word: "Romanos 12:2",        definition: "E não vos conformeis com este mundo, mas transformai-vos pela renovação do vosso entendimento, para que experimenteis qual seja a boa, agradável e perfeita vontade de Deus."),
            WordDefinition(word: "Romanos 8:28",        definition: "E sabemos que todas as coisas contribuem juntamente para o bem daqueles que amam a Deus, daqueles que são chamados por seu decreto."),
            WordDefinition(word: "Mateus 28:18",        definition: "E, chegando-se Jesus, falou-lhes, dizendo: É-me dado todo o poder no céu e na terra."),
            WordDefinition(word: "Colossenses 3:23",    definition: "E, tudo quanto fizerdes, fazei-o de todo o coração, como ao Senhor e não aos homens."),
            WordDefinition(word: "Miquéias 6:8",        definition: "Ele te declarou, ó homem, o que é bom; e que é o que o Senhor pede de ti, senão que pratiques a justiça, e ames a beneficência, e andes humildemente com o teu Deus?"),
            WordDefinition(word: "Mateus 28:20",        definition: "Ensinando-as a guardar todas as coisas que eu vos tenho mandado; e eis que eu estou convosco todos os dias, até à consumação dos séculos. Amém!"),
            WordDefinition(word: "Gálatas 2:20",        definition: "Já estou crucificado com Cristo; e vivo, não mais eu, mas Cristo vive em mim; e a vida que agora vivo na carne vivo-a na fé do Filho de Deus, o qual me amou e se entregou a si mesmo por mim."),
            WordDefinition(word: "1 Pedro 5:7",         definition: "Lançando sobre ele toda a vossa ansiedade, porque ele tem cuidado de vós."),
            WordDefinition(word: "1 Pedro 2:24",        definition: "Levando ele mesmo em seu corpo os nossos pecados sobre o madeiro, para que, mortos para os pecados, pudéssemos viver para a justiça; e pelas suas feridas fostes sarados."),
            WordDefinition(word: "João 1:12",           definition: "Mas a todos quantos o receberam deu-lhes o poder de serem feitos filhos de Deus: aos que creem no seu nome"),
            WordDefinition(word: "Mateus 6:33",         definition: "Mas buscai primeiro o Reino de Deus, e a sua justiça, e todas essas coisas vos serão acrescentadas."),
            WordDefinition(word: "Romanos 5:8",         definition: "Mas Deus prova o seu amor para conosco em que Cristo morreu por nós, sendo nós ainda pecadores."),
            WordDefinition(word: "Isaías 53:5",         definition: "Mas ele foi ferido pelas nossas transgressões e moído pelas nossas iniquidades; o castigo que nos traz a paz estava sobre ele, e, pelas suas pisaduras, fomos sarados."),
            WordDefinition(word: "Gálatas 5:22",        definition: "Mas o fruto do Espírito é: amor, gozo, paz, longanimidade, benignidade, bondade, fé, mansidão, temperança."),
            WordDefinition(word: "Isaías 40:31",        definition: "Mas os que esperam no Senhor renovarão as suas forças e subirão com asas como águias; correrão e não se cansarão; caminharão e não se fatigarão."),
            WordDefinition(word: "Atos 1:8",            definition: "Mas recebereis a virtude do Espírito Santo, que há de vir sobre vós; e ser-me-eis testemunhas tanto em Jerusalém como em toda a Judeia e Samaria e até aos confins da terra."),
            WordDefinition(word: "Tiago 1:2",           definition: "Meus irmãos, tende grande gozo quando cairdes em várias tentações"),
            WordDefinition(word: "João 5:24",           definition: "Na verdade, na verdade vos digo que quem ouve a minha palavra e crê naquele que me enviou tem a vida eterna e não entrará em condenação, mas passou da morte para a vida."),
            WordDefinition(word: "Hebreus 10:25",       definition: "Não deixando a nossa congregação, como é costume de alguns; antes, admoestando-nos uns aos outros; e tanto mais quanto vedes que se vai aproximando aquele Dia."),
            WordDefinition(word: "Filipenses 4:6",      definition: "Não estejais inquietos por coisa alguma; antes, as vossas petições sejam em tudo conhecidas diante de Deus, pela oração e súplicas, com ação de graças."),
            WordDefinition(word: "Josué 1:8",           definition: "Não se aparte da tua boca o livro desta Lei; antes, medita nele dia e noite, para que tenhas cuidado de fazer conforme tudo quanto nele está escrito; porque, então, farás prosperar o teu caminho e, então, prudentemente te conduzirás."),
            WordDefinition(word: "Isaías 41:10",        definition: "Não temas, porque eu sou contigo; não te assombres, porque eu sou o teu Deus; eu te esforço, e te ajudo, e te sustento com a destra da minha justiça."),
            WordDefinition(word: "Josué 1:9",           definition: "Não to mandei eu? Esforça-te e tem bom ânimo; não pasmes, nem te espantes, porque o Senhor, teu Deus, é contigo, por onde quer que andares."),
            WordDefinition(word: "1 Coríntios 10:13",   definition: "Não veio sobre vós tentação, senão humana; mas fiel é Deus, que vos não deixará tentar acima do que podeis; antes, com a tentação dará também o escape, para que a possais suportar."),
            WordDefinition(word: "Efésios 2:9",         definition: "Não vem das obras, para que ninguém se glorie."),
            WordDefinition(word: "Romanos 8:39",        definition: "Nem a altura, nem a profundidade, nem alguma outra criatura nos poderá separar do amor de Deus, que está em Cristo Jesus, nosso Senhor!"),
            WordDefinition(word: "João 15:13",          definition: "Ninguém tem maior amor do que este: de dar alguém a sua vida pelos seus amigos."),
            WordDefinition(word: "João 13:35",          definition: "Nisto todos conhecerão que sois meus discípulos, se vos amardes uns aos outros."),
            WordDefinition(word: "Gênesis 1:1",         definition: "No princípio, criou Deus os céus e a terra."),
            WordDefinition(word: "João 1:1",            definition: "No princípio, era o Verbo, e o Verbo estava com Deus, e o Verbo era Deus."),
            WordDefinition(word: "João 10:10",          definition: "O ladrão não vem senão a roubar, a matar e a destruir; eu vim para que tenham vida e a tenham com abundância."),
            WordDefinition(word: "Filipenses 4:19",     definition: "O meu Deus, segundo as suas riquezas, suprirá todas as vossas necessidades em glória, por Cristo Jesus."),
            WordDefinition(word: "Salmos 133:1",        definition: "Oh! Quão bom e quão suave é que os irmãos vivam em união!"),
            WordDefinition(word: "Hebreus 12:2",        definition: "Olhando para Jesus, autor e consumador da fé, o qual, pelo gozo que lhe estava proposto, suportou a cruz, desprezando a afronta, e assentou-se à destra do trono de Deus."),
            WordDefinition(word: "Hebreus 11:1",        definition: "Ora, a fé é o firme fundamento das coisas que se esperam e a prova das coisas que se não veem."),
            WordDefinition(word: "Efésios 3:20",        definition: "Ora, àquele que é poderoso para fazer tudo muito mais abundantemente além daquilo que pedimos ou pensamos, segundo o poder que em nós opera."),
            WordDefinition(word: "Atos 17:11",          definition: "Ora, estes foram mais nobres do que os que estavam em Tessalônica, porque de bom grado receberam a palavra, examinando cada dia nas Escrituras se estas coisas eram assim."),
            WordDefinition(word: "Romanos 15:13",       definition: "Ora, o Deus de esperança vos encha de todo o gozo e paz em crença, para que abundeis em esperança pela virtude do Espírito Santo."),
            WordDefinition(word: "Hebreus 11:6",        definition: "Ora, sem fé é impossível agradar-lhe, porque é necessário que aquele que se aproxima de Deus creia que ele existe e que é galardoador dos que o buscam."),
            WordDefinition(word: "1 Coríntios 6:19",    definition: "Ou não sabeis que o nosso corpo é o templo do Espírito Santo, que habita em vós, proveniente de Deus, e que não sois de vós mesmos?"),
            WordDefinition(word: "2 Pedro 1:4",         definition: "Pelas quais ele nos tem dado grandíssimas e preciosas promessas, para que por elas fiqueis participantes da natureza divina, havendo escapado da corrupção, que, pela concupiscência, há no mundo"),
            WordDefinition(word: "Hebreus 4:12",        definition: "Porque a palavra de Deus é viva, e eficaz, e mais penetrante do que qualquer espada de dois gumes, e penetra até à divisão da alma, e do espírito, e das juntas e medulas, e é apta para discernir os pensamentos e intenções do coração."),
            WordDefinition(word: "João 3:16",           definition: "Porque Deus amou o mundo de tal maneira que deu o seu Filho unigênito, para que todo aquele que nele crê não pereça, mas tenha a vida eterna."),
            WordDefinition(word: "João 3:17",           definition: "Porque Deus enviou o seu Filho ao mundo não para que condenasse o mundo, mas para que o mundo fosse salvo por ele."),
            WordDefinition(word: "2 Timóteo 1:7",       definition: "Porque Deus não nos deu o espírito de temor, mas de fortaleza, e de amor, e de moderação."),
            WordDefinition(word: "Romanos 8:38",        definition: "Porque estou certo de que nem a morte, nem a vida, nem os anjos, nem os principados, nem as potestades, nem o presente, nem o porvir."),
            WordDefinition(word: "Jeremias 29:11",      definition: "Porque eu bem sei os pensamentos que penso de vós, diz o Senhor; pensamentos de paz e não de mal, para vos dar o fim que esperais."),
            WordDefinition(word: "Atos 18:10",          definition: "Porque eu sou contigo, e ninguém lançará mão de ti para te fazer mal, pois tenho muito povo nesta cidade."),
            WordDefinition(word: "Hebreus 4:15",        definition: "Porque não temos um sumo sacerdote que não possa compadecer-se das nossas fraquezas; porém um que, como nós, em tudo foi tentado, mas sem pecado."),
            WordDefinition(word: "Mateus 11:30",        definition: "Porque o meu jugo é suave, e o meu fardo é leve."),
            WordDefinition(word: "Romanos 6:23",        definition: "Porque o salário do pecado é a morte, mas o dom gratuito de Deus é a vida eterna, por Cristo Jesus, nosso Senhor."),
            WordDefinition(word: "Isaías 55:8",         definition: "Porque os meus pensamentos não são os vossos pensamentos, nem os vossos caminhos, os meus caminhos, diz o Senhor."),
            WordDefinition(word: "Efésios 2:8",         definition: "Porque pela graça sois salvos, por meio da fé; e isso não vem de vós; é dom de Deus."),
            WordDefinition(word: "Efésios 2:10",        definition: "Porque somos feitura sua, criados em Cristo Jesus para as boas obras, as quais Deus preparou para que andássemos nelas."),
            WordDefinition(word: "Romanos 3:23",        definition: "Porque todos pecaram e destituídos estão da glória de Deus."),
            WordDefinition(word: "Mateus 28:19",        definition: "Portanto, ide, ensinai todas as nações, batizando-as em nome do Pai, e do Filho, e do Espírito Santo."),
            WordDefinition(word: "Hebreus 12:1",        definition: "Portanto, nós também, pois, que estamos rodeados de uma tão grande nuvem de testemunhas, deixemos todo embaraço e o pecado que tão de perto nos rodeia e corramos, com paciência, a carreira que nos está proposta."),
            WordDefinition(word: "Filipenses 4:13",     definition: "Posso todas as coisas naquele que me fortalece."),
            WordDefinition(word: "Filipenses 4:8",      definition: "Quanto ao mais, irmãos, tudo o que é verdadeiro, tudo o que é honesto, tudo o que é justo, tudo o que é puro, tudo o que é amável, tudo o que é de boa fama, se há alguma virtude, e se há algum louvor, nisso pensai."),
            WordDefinition(word: "Provérbios 3:6",      definition: "Reconhece-o em todos os teus caminhos, e ele endireitará as tuas veredas."),
            WordDefinition(word: "Colossenses 3:12",    definition: "Revesti-vos, pois, como eleitos de Deus, santos e amados, de entranhas de misericórdia, de benignidade, humildade, mansidão, longanimidade"),
            WordDefinition(word: "Romanos 12:1",        definition: "Rogo-vos, pois, irmãos, pela compaixão de Deus, que apresenteis o vosso corpo em sacrifício vivo, santo e agradável a Deus, que é o vosso culto racional."),
            WordDefinition(word: "Tiago 1:3",           definition: "Sabendo que a prova da vossa fé produz a paciência."),
            WordDefinition(word: "1 João 1:9",          definition: "Se confessarmos os nossos pecados, ele é fiel e justo para nos perdoar os pecados e nos purificar de toda injustiça."),
            WordDefinition(word: "Hebreus 13:5",        definition: "Sejam vossos costumes sem avareza, contentando-vos com o que tendes; porque ele disse: Não te deixarei, nem te desampararei."),
            WordDefinition(word: "Filipenses 1:6",      definition: "Tendo por certo isto mesmo: que aquele que em vós começou a boa obra a aperfeiçoará até ao Dia de Jesus Cristo."),
            WordDefinition(word: "João 16:33",          definition: "Tenho-vos dito isso, para que em mim tenhais paz; no mundo tereis aflições, mas tende bom ânimo; eu venci o mundo."),
            WordDefinition(word: "2 Timóteo 3:16",      definition: "Toda Escritura divinamente inspirada é proveitosa para ensinar, para redarguir, para corrigir, para instruir em justiça."),
            WordDefinition(word: "Isaías 53:6",         definition: "Todos nós andamos desgarrados como ovelhas; cada um se desviava pelo seu caminho, mas o Senhor fez cair sobre ele a iniquidade de nós todos."),
            WordDefinition(word: "Mateus 11:29",        definition: "Tomai sobre vós o meu jugo, e aprendei de mim, que sou manso e humilde de coração, e encontrareis descanso para a vossa alma."),
            WordDefinition(word: "Isaías 26:3",         definition: "Tu conservarás em paz aquele cuja mente está firme em ti; porque ele confia em ti."),
            WordDefinition(word: "Isaías 53:4",         definition: "Verdadeiramente, ele tomou sobre si as nossas enfermidades e as nossas dores levou sobre si; e nós o reputamos por aflito, ferido de Deus e oprimido."),
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
