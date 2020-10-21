function updateSeries(chart, data, start) {
  chart.series[0].update({
    data,
  })

  if (start) {
    chart.update({
      tooltip: {
        formatter: function() {
           return `<strong>${this.x+start}</strong><br> <strong>${this.y}%</strong> odd`;
        },
      },
      xAxis: {
        labels: {
          formatter: function() {
              return this.value + start;
          }
        },
      }
    })
  }
}

(async () => {
  const rawData = await (await fetch('odd.json')).json();

  const chart = Highcharts.chart('chart', {
    title: `Percentage of odd numbers in Pascal's triangle, by row`,
    yAxis: {
      title: {
        text: 'Percentage'
      }
    },
    xAxis: {
      labels: {
        formatter: function() {
          return this.value + 1;
        }
      },
    },
    chart: {
      zoomType: 'xy'
    },
    tooltip: {
      crosshairs: [true],
      formatter: function() {
         return `<strong>${this.x+1}</strong><br> <strong>${this.y}%</strong> odd`;
      },
    },
    series: [
      {
        name: '% odd',
        data: [],
      }
    ]
  });

  updateSeries(chart, rawData.slice(0, 1001), 1);

  const minEle = document.querySelector('#min');
  const maxEle = document.querySelector('#max');
  const minLabel = document.querySelector('label[for="min"]');
  const maxLabel = document.querySelector('label[for="max"]');

  minEle.addEventListener('input', (e) => {
    const { value } = e.target;
    const start = parseInt(value, 10) - 1;
    const end = parseInt(maxEle.value, 10);

    updateSeries(chart, rawData.slice(start, end), start+1);

    minLabel.innerHTML = `Minimum value (${value})`
  });

  maxEle.addEventListener('input', (e) => {
    const { value } = e.target;
    const start = parseInt(minEle.value, 10) - 1;
    const end = parseInt(value, 10);

    updateSeries(chart, rawData.slice(start, end));

    maxLabel.innerHTML = `Maximum value (${value})`;
  });
})();
