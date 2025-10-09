<p class="h2 mb-4">Métricas de envíos {$year}</p>


<div class="row">
    <!-- Columna izquierda: Tabla -->
    <div class="col-md-6 mb-3 mb-md-0">
        <p class="h4 mb-2">Estado de los envíos</p>
        <div class="table-responsive">
            <table class="table table-hover align-middle">
                <thead class="table-light">
                <tr>
                    <th scope="col">Estado</th>
                    <th scope="col" class="text-end">Total</th>
                </tr>
                </thead>
                <tbody>
                <tr>
                    <td><i class="bi bi-inbox"></i> Recibidos</td>
                    <td class="text-end fw-bold text-primary">{$submissions.received}</td>
                </tr>
                <tr>
                    <td><i class="bi bi-hourglass-split"></i> En cola</td>
                    <td class="text-end fw-bold text-secondary">{$submissions.queued}</td>
                </tr>
                <tr>
                    <td><i class="bi bi-journal-check"></i> Publicados</td>
                    <td class="text-end fw-bold text-success">{$submissions.published}</td>
                </tr>
                <tr>
                    <td><i class="bi bi-x-circle"></i> Rechazados</td>
                    <td class="text-end fw-bold text-danger">{$submissions.declined}</td>
                </tr>
                </tbody>
            </table>
        </div>
    </div>

    <!-- Columna derecha: Gráfica -->
    <div class="col-md-6 d-flex align-items-center">
        <canvas id="submissionsChart" width="400" height="300"></canvas>
    </div>
</div>

<script>
const dataSubmissions = {$submissions|json_encode};
const ctx = document.getElementById('submissionsChart').getContext('2d');
new Chart(ctx, {
    type: 'bar',
    data: {
        labels: ['Recibidos', 'En cola', 'Publicados', 'Rechazados'],
        datasets: [{
            label: 'Número de envíos',
            data: [dataSubmissions.received, dataSubmissions.queued, dataSubmissions.published, dataSubmissions.declined],
            backgroundColor: [
                'rgba(13, 110, 253, 0.5)',
                'rgba(108, 117, 125, 0.5)',
                'rgba(25, 135, 84, 0.5)',
                'rgba(220, 53, 69, 0.5)'
            ],
            borderColor: [
                'rgba(13, 110, 253, 1)',
                'rgba(108, 117, 125, 1)',
                'rgba(25, 135, 84, 1)',
                'rgba(220, 53, 69, 1)'
            ],
            borderWidth: 1
        }]
    },
    options: {
        responsive: true,
        scales: {
            y: {
                beginAtZero: true
            }
        }
    }
});
</script>