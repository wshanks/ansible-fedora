// This sets up the panel items/order/settings

widgets = ['org.kde.plasma.kickoff',
           'org.kde.plasma.panelspacer',
           'org.kde.plasma.systemmonitor.cpu',
           'org.kde.plasma.systemmonitor.memory',
           'org.kde.netspeedWidget',
           'org.kde.plasma.systemtray',
           'org.kde.plasma.digitalclock']

while (panelIds.length > 1) {
    panelById(panelIds[panelIds.length - 1]).remove()
}
if (panelIds.length == 0) {
    panel = new Panel()
} else {
    panel = panelById(panelIds[0])
}
panel.location = 'top'

// Remove extraneous widgets
widgetsSeen = []
for (i=panel.widgetIds.length-1; i>=0; i--) {
    widget = panel.widgetById(panel.widgetIds[i])
    if ((widgets.indexOf(widget.type) == -1) ||
            (widgetsSeen.indexOf(widget.type) != -1)) {
        widget.remove()
    }
    widgetsSeen.push(widget.type)
}

// Make sure widgets has no duplicates
widgets = widgets.filter(function(elem, pos, arr) {
    return arr.indexOf(elem) == pos
})

currentWidgets = []
for (i=0; i<panel.widgetIds.length; i++) {
    currentWidgets.push(panel.widgetById(panel.widgetIds[i]).type)
}

for (i=0; i<widgets.length; i++) {
    if (currentWidgets.indexOf(widgets[i]) == -1) {
        panel.addWidget(widgets[i])
        currentWidgets.push(widgets[i])
    }
}

AppletOrder = []
for (i=0; i<widgets.length; i++) {
    for (j=0; j<panel.widgetIds.length; j++) {
        if (panel.widgetById(panel.widgetIds[j]).type == widgets[i]) {
            AppletOrder.push(panel.widgetIds[j])
            break
        }
    }
}
panel.writeConfig('AppletOrder', AppletOrder)

for (i=0; i<panel.widgetIds.length; i++) {
    widget = panel.widgetById(panel.widgetIds[i])
    if (widget.type == 'org.kde.plasma.systemmonitor.cpu') {
        widget.currentConfigGroup = new Array('General')
        widget.writeConfig('sources', 'cpu%2Fsystem%2FTotalLoad')
    } else if (widget.type == 'org.kde.plasma.systemmonitor.memory') {
        widget.currentConfigGroup = new Array('General')
        widget.writeConfig('sources', 'mem%2Fphysical%2Fapplication')
    }
}
