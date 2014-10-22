import QtQuick 2.0

Flickable {

    id : objImgId
    property string imgSource
    property string imgName
    property string backColor
    property double weight : 0.00
    property double volume : 0.00
    property double density : 0.00
    property int parentX : 0
    property int parentY : 0
    z: 10
    state : "inGrid"

    Image {
        id : imageArea
        width: objImgId.width
        height: objImgId.height
        source: objImgId.imgSource
        z : 10

        Drag.active: imageMouseArea.drag.active
        Drag.source: objImgId

        MouseArea {
            id: imageMouseArea
            hoverEnabled: true
            anchors.fill: imageArea
            drag.target: (objImgId.parent.dragEnabled === true || objImgId.state != "inGrid") ? imageArea : null


            onEntered: {
                imgText.textVisible = true
                imgText.mouseX = mouseX
                imgText.mouseY = mouseY
            }
            onMouseXChanged: {
                imgText.mouseX = mouseX
            }

            onMouseYChanged: {
                imgText.mouseY = mouseY
            }

            onExited: {
                imgText.textVisible = false
            }

            onClicked: {
            }
            onReleased: {
                imgText.textVisible = false
                imageArea.Drag.drop()
            }
        }

        Item {
            id : imgText
            property bool textVisible : false
            property real mouseX: 0
            property real mouseY: 0
            z : 10

            Text {
                x: imgText.mouseX + 10
                y: imgText.mouseY + 5
                z: 100
                visible: imgText.textVisible
                text : imgName
                wrapMode: Text.WordWrap



            }

        }
    }
    function changePosition(x, y) {
        objImgId.y = y
        objImgId.x = x
    }


    states: [
        State {
            name: "inGrid"
        },
        State {
            name: "inWeight"
        },
        State {
            name: "inVolume"
        },
        State {
            name: "none"
        }
    ]

    function setState(newState) {
        state = newState
    }
    function disableParentDragging(){
        this.parent.disableDragging()
    }
    function enableParentDragging(){
        this.parent.enableDragging()
    }
    function updaetVolume(volume) {
        this.volume = volume
    }

    function getCalculatedVolume() {
        return weight / density;
    }

    function getVolume() {
        return volume;
    }

    /*
    How much is submerged depends on the density of the object, as compared to the fluid. The equation is:
            ρf * Vs = ρo * Vo
        where
            ρf is the density of the fluid
     Vs is the volume submerged
            ρo is the density of the object
        Vo is the volume of the whole object
            ρV is ρ times V
    */
    function getSubMergedHeight(liquidDensity) {
        var subMergedVol = (density * getCalculatedVolume()) / liquidDensity
        var subMergedPer =  subMergedVol / getCalculatedVolume()
        return height * subMergedPer
    }

    function getSinkStatus(liquidDensity) {
        if(getSubMergedHeight(liquidDensity) < height) {
            return "float"
        }else{
            return "sinks"
        }
    }
    Behavior on x {
        PropertyAnimation { duration: 400; }
    }
    Behavior on y {
        PropertyAnimation { duration: 400; }
    }
    function reset() {

    }

}