<p class="h2 mb-4">Estadísticas de artículos {$year}</p>

<div class="card mb-4">
    <div class="card-body">
        <canvas id="articleStatisticsChart" width="800" height="400"></canvas>
    </div>
</div>

<div class="card">
    <pre>{$articlesByYear|@print_r}</pre>
</div>

<script>
    const articlesByYear = {$articlesByYear|json_encode};
    const labels = articlesByYear.map(item => item.month.toString().slice(4,6));
    const totalInvestigations = articlesByYear.map(item => item.total_investigations);
    const totalRequests = articlesByYear.map(item => item.total_requests);

    const ctx = document.getElementById('articleStatisticsChart').getContext('2d');
    new Chart(ctx, {
        type: 'bar',
        data: {
            labels: labels,
            datasets: [
                { label: 'Visitas', data: totalInvestigations, backgroundColor: 'rgba(54, 162, 235, 0.7)' },
                { label: 'Descargas', data: totalRequests, backgroundColor: 'rgba(255, 99, 132, 0.7)' }
            ]
        },
        options: { responsive: true }
    });
</script>
