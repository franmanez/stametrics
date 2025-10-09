<p class="h2 mb-4">Usuarios registrados {$year}</p>

<div class="row">
    <!-- Columna izquierda: Tabla -->
    <div class="col-md-6 mb-3 mb-md-0">
        <p class="h4 mb-3">Usuarios registrados</p>
        <div class="table-responsive">
            <table class="table table-hover align-middle">
                <thead class="table-light">
                <tr>
                    <th scope="col">Roles</th>
                    <th scope="col" class="text-end">Total</th>
                </tr>
                </thead>
                <tbody>
                <tr>
                    <td><i class="bi bi-pencil-square"></i> Autores</td>
                    <td class="text-end fw-bold">{$userCountAuthor}</td>
                </tr>
                <tr>
                    <td><i class="bi bi-search"></i> Revisores</td>
                    <td class="text-end fw-bold">{$userCountReviewer}</td>
                </tr>
                <tr>
                    <td><i class="bi bi-book"></i> Lectores</td>
                    <td class="text-end fw-bold">{$userCountReader}</td>
                </tr>
                <tr>
                    <td><i class="bi bi-people"></i> Total de usuarios</td>
                    <td class="text-end h4 fw-bold text-danger">{$userCount}</td>
                </tr>
                </tbody>
            </table>
        </div>
    </div>

    <!-- Columna derecha: Gráfica -->
    <div class="col-md-6 d-flex align-items-center">
        <canvas id="usersChart" width="400" height="300"></canvas>
    </div>
</div>


<script>
    const ctx = document.getElementById('usersChart').getContext('2d');
    new Chart(ctx, {
        type: 'doughnut',
        data: {
            labels: ['Autores','Revisores','Lectores'],
            datasets: [{ data: [{$userCountAuthor}, {$userCountReviewer}, {$userCountReader}], backgroundColor: ['rgba(253, 97, 13, 0.5)','rgba(248,209,23,0.5)','rgba(108,117,125,0.5)'] }]
        },
        options: { responsive: true, cutout: '50%' }
    });
</script>
