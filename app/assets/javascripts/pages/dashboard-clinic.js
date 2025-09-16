/**
 * Theme: Osen - Responsive Bootstrap 5 Admin Dashboard
 * Author: Coderthemes
 * Module/App: Clinic Dashboard
 */


///
var colors = ["#727cf5", "#0acf97", "#fa5c7c", "#ffbc00"];
var dataColors = $("#sessions-overview-users").data('colors');
if (dataColors) {
    colors = dataColors.split(",");
}

var options = {
    series: [{
        name: 'Abonos',
        type: 'bar',
        data: [16,19,19,16,16,14,15,15,17,17,19,19,18,18,20,20,18,18,22,22,20,20,18,18,20,20,18,20,20,22]
    }, {
        name: 'Prestamos',
        type: 'bar',
        data: [21,24,24,21,21,19,20,20,22,22,24,24,23,23,25,25,23,23,27,27,25,25,23,23,25,25,23,25,25,27]
    }],
    stroke: {
        width: [0, 2],
        dashArray: [5, 0],
    },
    colors: colors,
    grid: {
        strokeDashArray: 7,
        padding: {
            top: 0,
            right: -10,
            bottom: 15,
            left: -10,
        },
    },
    zoom: {
        enabled: false
    },
    xaxis: {
        type: 'string',
        axisBorder: {
            show: false,
        },
        labels: {
            offsetY: 2
        },
    },
    yaxis: {
        tickAmount: 3,
        min: 0,
        labels: {
            formatter: function (val) {
                return val + "k";
            },
            offsetX: -15
        },
        axisBorder: {
            show: false,
        }
    },
    legend: {
        show: true,
        horizontalAlign: "center",
        offsetX: 0,
        offsetY: 5,
        markers: {
            width: 9,
            height: 9,
            radius: 6,
        },
        itemMargin: {
            horizontal: 5,
            vertical: 0,
        },
    },
    dataLabels: {
        enabled: false
    },
    markers: {
        size: 0,
    },
    tooltip: {
        x: {
            format: 'dd MMM yyyy'
        }
    },
    fill: {
        opacity: [1, 0.5],
        type: ['solid', 'gradient'],
        gradient: {
            type: "vertical",
            inverseColors: false,
            opacityFrom: 0.35,
            opacityTo: 0,
            stops: [0, 80]
        },
    },
    plotOptions: {
        bar: {
            columnWidth: "50%",
            barHeight: "70%",
            borderRadius: 3,
        },
    },
}

var chart = new ApexCharts(
    document.querySelector("#sessions-overview-users"),
    options
);

chart.render();


//
// Gender Chart
//
var colors = ["#727cf5", "#0acf97", "#fa5c7c", "#ffbc00"];
var dataColors = $("#gender-chart").data('colors');
if (dataColors) {
    colors = dataColors.split(",");
}
var options = {
    chart: {
        height: 277,
        type: 'donut',
    },
    legend: {
        show: false
    },
    stroke: {
        width: 0
    },
    plotOptions: {
        pie: {
            donut: {
                size: '75%',
                labels: {
                    show: true,
                    total: {
                        showAlways: true,
                        show: true
                    }
                }
            }
        }
    },
    series: [159.5, 148.56, 45.2],
    labels: ["Male", "Female", "Child"],
    colors: colors,
    dataLabels: {
        enabled: false
    },
    responsive: [{
        breakpoint: 480,
        options: {
            chart: {
                width: 200
            }
        }
    }]
}

var chart = new ApexCharts(
    document.querySelector("#gender-chart"),
    options
);

chart.render();
