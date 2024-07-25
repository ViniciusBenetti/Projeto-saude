import Felgo 4.0
import QtQuick 2.0
import QtQuick.Window 
import QtQuick.Controls 
import QtQuick.Dialogs



App{
    FontLoader {
        id: roboto
        source: "../assets/fonts/Roboto-Regular.ttf"
    }
    Storage{
     id:storage 

     Component.onCompleted:{
        console.log("start")
        var item = storage.getValue("dados-salvos")
        if(item){
            var dadosParse =  JSON.parse(item)
            console.log(item)
            
            for (var i = 0; i < dadosParse.length; ++i) {
                listaEX.model.append({title: dadosParse[i]["nome-exame"],
           body:"<br/>"+dadosParse[i]["data-exame"]+
                     "<br/>doutor: "+dadosParse[i]["nome-doutor"] +
                     "<br/>ver detalhes..."
 
            });
            }
           
        }
     }
    }
    Item {
    FileDialog {
        id: fileDialog
        title: "Selecione um arquivo"
        selectedNameFilter.index: 1
        nameFilters: ["pdf selecionado (*.pdf)"]

        onAccepted: {

            image.text =  fileDialog.selectedNameFilter.name
        }
        onRejected:{
            image.text = "erro ao inserir arquivo"
        }
    }
}


  onInitTheme:{

     Theme.navigationBar.backgroundColor = "#ffb600"
     Theme.colors.backgroundColor = "black"
     Theme.navigationTabBar.backgroundColor = "#ffb600"
     Theme.navigationTabBar.titleOffColor = "#ffb600"
     Theme.colors.textColor = "white"



   }



    NavigationStack{
        


        AppPage{



            titleItem: Text{
            font.pixelSize: 24 
            color: "white"
            text: "Meus Exames"
            font.family: roboto.font

           AppIcon {
                    iconType: IconType.heart
                    color: "red"
                    anchors.left: parent.right
                    anchors.leftMargin: 5
                    size: 24 
                    height: parent.height
                }
            }

    Rectangle{
        width: parent.width
        anchors.top: parent.top
        anchors.topMargin: 30

    IconButton{
         iconType: IconType.filter 
         color: "gray"
         scale: 1.5
    }

    AppTextField {
      id:textoedit
      width: parent.width / 1.25
      anchors.bottom: listaEX.top
      anchors.horizontalCenter: parent.horizontalCenter
      height: 30
      anchors.bottomMargin: 30
      placeholderColor: "gray"
      textColor: "white"
      underlineColor: "gray"
      placeholderText: "pesquisar"
      font: roboto.font

      
    }
    IconButton{
         iconType: IconType.search
         color: "gray"
         anchors.left: textoedit.right
    }

}Popup{

     id:popup2
      x: 50
      y: 100
      width: 300
      height: 450
      modal: true
      focus: true
      closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent
        background: Rectangle {
        border.color: "gray"
        radius: 20
        color: "black"
    }

    AppText{
        id: titulo
        text: ""
        color: "white"
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        font.family: roboto.font
        font.pixelSize: 20

    }
    }

   AppListView {
    id: listaEX
    width: parent.width
    anchors.top: parent.top
    anchors.topMargin: 100
    anchors.bottom: parent.bottom
    model: ListModel {}
    delegate: Rectangle {
        id: retangulo
        width: parent.width
        height: 150
        color: "#4a4a4a"

        

        SwipeOptionsContainer {
            anchors.fill: parent

            rightOption: SwipeButton {
                iconType: IconType.pencil
                backgroundColor: "green"
                onClicked:{

                    var dados = storage.getValue("dados-salvos")
                    if(dados){
                        var parseDados = JSON.parse(dados)
  
                        var obs = parseDados[model.index]["observacoes"]
                        nomeExame.text = parseDados[model.index]["nome-exame"]
                        nomeDoutor.text = parseDados[model.index]["nome-doutor"]
                        observacoesExame.text = obs

                    }else{
                        console.log("sem obs")
                    }



                    popup.open()
                }
            }

            leftOption: SwipeButton {

                iconType: IconType.trash
                backgroundColor: "red"
                onClicked:{
                    var dados = storage.getValue("dados-salvos")
                    if(dados){
                        var parseDados = JSON.parse(dados)
                        parseDados.splice(model.index, 1);

                        listaEX.model.remove(model.index)
                        storage.setValue("dados-salvos",JSON.stringify(parseDados))

                    }else{
                        console.log("nao deletou")
                    }
                    
                }
            }

            Text {
                MouseArea {
                  anchors.fill: parent
                  onClicked:{
                    console.log(model.index)
                  }
                }
                font.pixelSize: 18
                anchors.top: parent.top
                anchors.topMargin: 5
                anchors.left: parent.left
                anchors.leftMargin: 10
                text: model.title + "<br/> <br/>" + model.body
                color: "white"
            }


        }

        Rectangle {
            width: parent.width
            height: 2
            anchors.bottom: parent.bottom 
            color: "black"
        }
    }
}
Rectangle{
   anchors.bottom: parent.bottom
   anchors.right: parent.right
   color: "black"
   width: 80
   height: 80
   radius: 100
   anchors.bottomMargin: 20 
   anchors.rightMargin:20

 IconButton {
   property bool adcFlag: false
   id:adicionarFlag
   iconType: IconType.plus
   scale:2
   anchors.centerIn:parent
   color: "gray"
    onClicked:{
    adcFlag = true
    popup.open()
   }

 }  
}Popup {
        
    id: popup
    x: 50
    y: 100
    width: 300
    height: 620
    modal: true
    focus: true
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent

    background: Rectangle {
        border.color: "gray"
        radius: 20
        color: "black"
    }
    AppText{
        text: "tipo de exame:" 
        color: "white"
        anchors.top: parent.top
        anchors.topMargin:20
    }
    AppTextField{
        id:nomeExame
        anchors.top: parent.top
        anchors.topMargin:50
        placeholderColor: "gray"
        textColor: "white"
        underlineColor: "white"
        width: parent.width / 2
        font: roboto.font

    }
     AppText{
        text: "data do exame:" 
        color: "white"
        anchors.top: parent.top
        anchors.topMargin:100
    }
    DatePicker {
        id: dataExame
        anchors.top:parent.top 
        anchors.topMargin: 120
        width: parent.width
        height: 140 
       dateFormat: "dd-MM-yyyy"
    }
    AppText{
        text: "nome do doutor(a):"
        anchors.top:parent.top 
        anchors.topMargin: 280
    }
     AppTextField{
        id:nomeDoutor
        anchors.top: parent.top
        anchors.topMargin:310
        placeholderColor: "gray"
        textColor: "white"
        underlineColor: "white"
        width: parent.width / 2
        font: roboto.font

    }
    AppText{
        anchors.top: parent.top
        anchors.topMargin:350
        text: "observações:"
    }
    AppTextField{
        id:observacoesExame
        anchors.top: parent.top
        anchors.topMargin:380
        placeholderColor: "gray"
        textColor: "white"
        underlineColor: "white"
        width: parent.width 
        font: roboto.font

    }
    AppText{
        text: "enviar arquivo: (.pdf):"
        anchors.top:parent.top 
        anchors.topMargin: 430
    }

    AppButton{
        text:"selecionar"
        anchors.top:parent.top 
        anchors.topMargin: 460
        onClicked: {fileDialog.open()}
        radius: 40
        anchors.horizontalCenter: parent.horizontalCenter 
        backgroundColor: "#4a4a4a"
        backgroundColorPressed: "gray"
        
}

    AppText{
        id:image
        anchors.top:parent.top 
        anchors.topMargin: 510
        text: "nenhum arquivo selecionado"
    }

    AppButton{
    text:"salvar e sair"
    width: parent.width  
    anchors.top: parent.top  
    anchors.topMargin: 540
    radius: 40 
    backgroundColor: "#4a4a4a"
    backgroundColorPressed: "gray"
    onClicked:{

        if(nomeExame.text && nomeDoutor.text && image.text == "pdf selecionado"){
        var pegarSalvos = storage.getValue("dados-salvos")
        var dataEscolhida = dataExame.selectedDate.toLocaleDateString()
        if(pegarSalvos){
            var dadosParse = JSON.parse(pegarSalvos)
            var template = {"nome-exame":nomeExame.text,"data-exame":dataEscolhida,"nome-doutor":nomeDoutor.text,"observacoes":observacoesExame.text,"caminho-pdf":fileDialog.selectedFile}
            if(adicionarFlag.adcFlag == true){
            dadosParse.push(template)
            adicionarFlag.adcFlag = false

            }else{
            dadosParse.splice(listaEX.model.index, 1, template)
            }
            listaEX.model.clear()
            storage.clearAll()
            storage.setValue("dados-salvos",JSON.stringify(dadosParse))
     

            for (var i = 0; i < dadosParse.length; ++i) {
                listaEX.model.append({title: dadosParse[i]["nome-exame"],
           body:"<br/>"+dadosParse[i]["data-exame"]+
                     "<br/>doutor: "+dadosParse[i]["nome-doutor"] +
                     "<br/>ver detalhes..."
 
            });
            }

        }else{
        pegarSalvos = []
         var template = {"nome-exame":nomeExame.text,"data-exame":dataEscolhida,"nome-doutor":nomeDoutor.text,"observacoes":observacoesExame.text}
            pegarSalvos.push(template)
            listaEX.model.clear()
            storage.clearAll()
            storage.setValue("dados-salvos",JSON.stringify(pegarSalvos))
            listaEX.model.append({title: nomeExame.text,
           body:"<br/>"+dataExame.selectedDate.toLocaleDateString()+
               "<br/>doutor: "+nomeDoutor.text +
               "<br/>ver detalhes..."
 
            });

        }
        popup.close()

    }
    }

}

    


}          
            }
    
    }

}
