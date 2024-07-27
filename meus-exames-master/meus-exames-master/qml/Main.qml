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
            
            for (var i = 0; i < dadosParse.length; ++i) {
                listaEX.model.append({title: dadosParse[i]["nome-exame"],
           body:"<br/>"+dadosParse[i]["data-exame"]+
                     "<br/>doutor(a): "+dadosParse[i]["nome-doutor"] +
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
            property int modeloSalvo: 0
            id:pagina
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
         onClicked:{
            titulo.text = "Ordenar exames"
            popup2.open()
         }
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
      closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
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
    Column {
        anchors.top: parent.top  
        anchors.topMargin: 70
        
        RadioButton {
        id: radio1
        width: 40
        height: 30
        anchors.top: parent.top 
        anchors.topMargin:50
        contentItem: Text {
        text: "nome do exame(A-Z)"
        color: "white" 
        anchors.left: parent.right 

    }
    onClicked:{
            var dadosSalvos = storage.getValue("dados-salvos")
            if(dadosSalvos){
                var dadosParse = JSON.parse(dadosSalvos);
                listaEX.model.clear()
                 dadosParse.sort(function(a, b) {

                    return a["nome-exame"].localeCompare(b["nome-exame"]);
                });
                storage.setValue("dados-salvos",JSON.stringify(dadosParse))
                dadosParse.forEach(function(el) {
                listaEX.model.append({
                    title: el["nome-exame"],
                    body: "<br/>" + el["data-exame"] +                         "<br/>doutor(a): " + el["nome-doutor"] +
                          "<br/>ver detalhes..."
                });
            });
                
            }
        }

        }

        RadioButton {
        id: radio2
        anchors.top: parent.top 
        anchors.topMargin:100
        width: 40 
        height: 30
        contentItem: Text {
        text: "mais recentes primeiro"
        color: "white" 
        anchors.left: parent.right 

    }
      onClicked:{
        function parseData(dataString) {
        var partes = dataString.split(" ");
        if (partes.length < 6) { // Agora verificamos se temos pelo menos 6 partes
            console.error("Formato de data inválido. Certifique-se de que a entrada esteja no formato correto.");
            return null;
        }
        var dia = parseInt(partes[1].replace(",", ""), 10);
        var mesNomes = ["janeiro", "fevereiro", "março", "abril", "maio", "junho", "julho", "agosto", "setembro", "outubro", "novembro", "dezembro"];
        var mes = mesNomes.indexOf(partes[3]);
        if (mes === -1) {
            console.error("Nome do mês inválido. Verifique se o mês está escrito corretamente.");
            return null;
        }
        var ano = parseInt(partes[5], 10);
        mes = mes+1
        var dataISO = ano + "-" + (mes< 10 ? "0" : "") + mes + "-" + (dia < 10 ? "0" : "") + dia;
        return new Date(dataISO);
    }

            var dadosSalvos = storage.getValue("dados-salvos")
            if(JSON.parse(dadosSalvos).length > 1){

                var dadosParse = JSON.parse(dadosSalvos);
                listaEX.model.clear()
                 dadosParse.sort(function(a, b) {    
            
                var dataA = parseData(a["data-exame"]);
                var dataB = parseData(b["data-exame"]);
                return dataA - dataB;

                });
                storage.setValue("dados-salvos",JSON.stringify(dadosParse))
                dadosParse.forEach(function(el) {
                listaEX.model.append({
                    title: el["nome-exame"],
                    body: "<br/>" + el["data-exame"] +
                        "<br/>doutor(a): " + el["nome-doutor"] +
                        "<br/>ver detalhes..."
                });
            });
                
            }
        }

        }
         RadioButton {
        id: radio3
        anchors.top: parent.top 
        anchors.topMargin:150
        width: 40 
        height: 30
        contentItem: Text {
        text: "menos recentes primeiro"
        color: "white" 
        anchors.left: parent.right

    }
    onClicked:{
    function parseData(dataString) {
        var partes = dataString.split(" ");
        if (partes.length < 6) { // Agora verificamos se temos pelo menos 6 partes
            console.error("Formato de data inválido. Certifique-se de que a entrada esteja no formato correto.");
            return null;
        }
        var dia = parseInt(partes[1].replace(",", ""), 10);
        var mesNomes = ["janeiro", "fevereiro", "março", "abril", "maio", "junho", "julho", "agosto", "setembro", "outubro", "novembro", "dezembro"];
        var mes = mesNomes.indexOf(partes[3]);
        if (mes === -1) {
            console.error("Nome do mês inválido. Verifique se o mês está escrito corretamente.");
            return null;
        }
        var ano = parseInt(partes[5], 10);
        mes = mes+1
        var dataISO = ano + "-" + (mes< 10 ? "0" : "") + mes + "-" + (dia < 10 ? "0" : "") + dia;
        return new Date(dataISO);
    }

            var dadosSalvos = storage.getValue("dados-salvos")
            if(JSON.parse(dadosSalvos).length > 1){

                var dadosParse = JSON.parse(dadosSalvos);
                listaEX.model.clear()
                 dadosParse.sort(function(a, b) {    
            
                var dataA = parseData(a["data-exame"]);
                var dataB = parseData(b["data-exame"]);
                return dataB - dataA;

                });
                storage.setValue("dados-salvos",JSON.stringify(dadosParse))
                dadosParse.forEach(function(el) {
                listaEX.model.append({
                    title: el["nome-exame"],
                    body: "<br/>" + el["data-exame"] +
                        "<br/>doutor(a): " + el["nome-doutor"] +
                        "<br/>ver detalhes..."
                });
            });
                
            }
        
        }
        }
         RadioButton {
        id: radio4
        anchors.top: parent.top 
        anchors.topMargin:200
        width: 40 
        height: 30
        contentItem: Text {
        text: "nome do doutor(A-Z)"
        color: "white"
        anchors.left: parent.right 

    }onClicked:{
            var dadosSalvos = storage.getValue("dados-salvos")
            if(dadosSalvos){
                var dadosParse = JSON.parse(dadosSalvos);
                listaEX.model.clear()
                 dadosParse.sort(function(a, b) {

                    return a["nome-doutor"].localeCompare(b["nome-doutor"]);
                });
                storage.setValue("dados-salvos",JSON.stringify(dadosParse))
                dadosParse.forEach(function(el) {
                listaEX.model.append({
                    title: el["nome-exame"],
                    body: "<br/>" + el["data-exame"] +                         "<br/>doutor(a): " + el["nome-doutor"] +
                          "<br/>ver detalhes..."
                });
            });
                
            }
        }   


    

        }
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
        visible: shouldShowItem(title)
        width: listaEX.width
        layer.enabled: true
        height: 150
        color: "#4a4a4a"


     function shouldShowItem(itemTitle) {
    return textoedit.text === "" || itemTitle === textoedit.text
}   

        SwipeOptionsContainer {
            anchors.fill: parent

            rightOption: SwipeButton {
                iconType: IconType.pencil
                backgroundColor: "green"
                onClicked:{
                    function obterIndiceDoMes(mes) {
                    var meses = [
                        'janeiro', 'fevereiro', 'março', 'abril',
                        'maio', 'junho', 'julho', 'agosto',
                        'setembro', 'outubro', 'novembro', 'dezembro'
                    ];

                    var indice = meses.findIndex(m => m.toLowerCase() === mes.toLowerCase());
                    return indice !== -1 ? indice : null;



}
                    adicionarFlag.adcFlag = false
                    var dados = storage.getValue("dados-salvos")
                    pagina.modeloSalvo = model.index 
                    if(dados){
                        var parseDados = JSON.parse(dados)
                        
                        var matchInicioData= listaEX.model.get(model.index).body.indexOf('>') + 1
                        var matchFimData = listaEX.model.get(model.index).body.indexOf('<',matchInicioData)
                        var localeData = listaEX.model.get(model.index).body.substring(matchInicioData,matchFimData)

                        var matchInicioDoutor = listaEX.model.get(model.index).body.indexOf('>', matchInicioData) + 11
                        var matchFimDoutor = listaEX.model.get(model.index).body.indexOf('<', matchInicioDoutor);

                        var doutor = listaEX.model.get(model.index).body.substring(matchInicioDoutor+1, matchFimDoutor);
        
                    var partes = localeData.match(/(\d{1,2}) de (\w+) de (\d{4})/);
                    var dia = parseInt(partes[1]);
                    var mes = partes[2];
                    var ano = parseInt(partes[3]);
                    var data = new Date(ano, obterIndiceDoMes(mes), dia);
     
    
                    nomeExame.text = listaEX.model.get(model.index).title
                    dataExame.selectedDate = data
                    nomeDoutor.text = doutor
                    fileDialog.selectedFile = parseDados[model.index]["caminho-pdf"]
                    observacoesExame.text = parseDados[model.index]["observacoes"]


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
                    var dados = storage.getValue("dados-salvos")
                    pagina.modeloSalvo = model.index 

                    if(dados){
                        var parseDados = JSON.parse(dados)
   
                                 
                textoPopup3.text = listaEX.model.get(model.index).title
                observacoesExamePopup3.text = parseDados[model.index]["observacoes"]
                popup3.open()
                }
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
    nomeExame.text = ""
    nomeDoutor.text = ""
    image.text = "nenhum arquivo selecionado"
    observacoesExame.text = ""
    popup.open()
   }

 }  
}Popup{
    id:popup3
    x: 50
    y: 100
    width: 300
    height: 450
    modal: true
    focus: true
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
        background: Rectangle {
        border.color: "gray"
        radius: 20
        color: "black"
    }
    AppText{
        id:textoPopup3
        text: "" 
        color: "white"
        anchors.top: parent.top
        anchors.topMargin:20
        anchors.horizontalCenter: parent.horizontalCenter
    
    }
    AppTextField{
        id:observacoesExamePopup3
        anchors.top: parent.top
        anchors.topMargin:100
        placeholderColor: "gray"
        textColor: "white"
        underlineColor: "white"
        width: parent.width 
        font: roboto.font
        text:""
        readOnly: true

    }
        AppButton{
        id:verpdf
        text:"ver pdf"
        anchors.top:parent.top 
        anchors.topMargin: 200
        onClicked: {
            var dados = storage.getValue("dados-salvos")
       
            if(dados){
            var parseDados = JSON.parse(dados)
            console.log(pagina.modeloSalvo)
            Qt.openUrlExternally(parseDados[pagina.modeloSalvo]["caminho-pdf"])
            }
        }
        radius: 40
        anchors.horizontalCenter: parent.horizontalCenter 
        backgroundColor: "#4a4a4a"
        backgroundColorPressed: "gray"
        
}

        }

Popup {
        
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
        text: "nome do exame:" 
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
        text: "enviar arquivo:"
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
    text:"salvar"
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
            }else{
   
            dadosParse.splice(pagina.modeloSalvo, 1, template)
            }
            listaEX.model.clear()
            storage.setValue("dados-salvos",JSON.stringify(dadosParse))
     

            for (var i = 0; i < dadosParse.length; ++i) {
                listaEX.model.append({title: dadosParse[i]["nome-exame"],
           body:"<br/>"+dadosParse[i]["data-exame"]+
                     "<br/>doutor(a): "+dadosParse[i]["nome-doutor"] +
                     "<br/>ver detalhes..."
 
            });
            }

        }else{
        pegarSalvos = []
         var template = {"nome-exame":nomeExame.text,"data-exame":dataEscolhida,"nome-doutor":nomeDoutor.text,"observacoes":observacoesExame.text}
            pegarSalvos.push(template)
            listaEX.model.clear()
            storage.setValue("dados-salvos",JSON.stringify(pegarSalvos))
            listaEX.model.append({title: nomeExame.text,
           body:"<br/>"+dataExame.selectedDate+
               "<br/>doutor(a): "+nomeDoutor.text +
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
