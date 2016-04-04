$(function () {
    var handler = Gmaps.build('Google', { markers: { clusterer: {gridSize: 30, maxZoom: 15}  }  });

    handler.setOptions({markers: { do_clustering: true }})
    handler.buildMap({ provider: {}, internal: {id: 'map'}}, function(){
        var markers = [];

        $(".service").each(function (index, row) {
            var $row = $(row), datum = $row.data(), marker, id = datum.id,
            white_icon = {
                url: "http://chart.apis.google.com/chart?chst=d_map_pin_letter&chld=" + (index + 1) + "|F9F9F9|000000",
                width: 32,
                height: 32
            },
            green_icon = {
                url: "http://chart.apis.google.com/chart?chst=d_map_pin_letter&chld=" + (index + 1) + "|DFF0D8|000000",
                width: 32,
                height: 32
            }

            datum.picture = white_icon;

            marker = handler.addMarker(datum);
            markers.push(marker);

            $row.on('mouseover', function () {
                marker.getServiceObject().setIcon(green_icon)
            });

            $row.on('mouseout', function () {
                marker.getServiceObject().setIcon(white_icon)
            });

            marker.getServiceObject().addListener("mouseover", function (point) {
                $("tr[data-id=" + id + "]").addClass("success");
            });

            marker.getServiceObject().addListener("mouseout", function (point) {
                $("tr[data-id=" + id + "]").removeClass("success");
            });
        });

        handler.bounds.extendWith(markers);
        handler.fitMapToBounds();
    });

});
