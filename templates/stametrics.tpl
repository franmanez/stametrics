{* stats.tpl *}
<script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

<script>
    $(document).ready(function() {
        // Pasar un número desde Smarty a JS
        const year = {$year|json_encode};
        const dataSubmissions = {$submissions|json_encode};

        console.log(year);
        console.log(JSON.stringify(dataSubmissions));

        const data = {
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
        }

        const config1 = {
            type: 'bar',
            data: data,
            options: {
                responsive: true,
                scales: {
                    y: {
                        beginAtZero: true
                    }
                }
            }
        };


        const ctx = document.getElementById('myChart').getContext('2d');
        const myChart = new Chart(ctx, config1);


        const dataUsers = {
            labels: ['Autores', 'Revisores', 'Lectores'],
            datasets: [{
                label: 'Número de envíos',
                data: [{$userCountAuthor|json_encode}, {$userCountReviewer|json_encode}, {$userCountReader|json_encode}],
                backgroundColor: [
                    'rgb(253, 97, 13, 0.5)',
                    'rgba(248,209,23,0.5)',
                    'rgba(108, 117, 125, 0.5)',
                ],
                borderColor: [
                    'rgb(253, 97, 13, 1)',
                    'rgba(248, 209 ,23, 1)',
                    'rgba(108, 117, 125, 1)',
                ],
                borderWidth: 1
            }]
        }

        const config2 = {
            type: 'doughnut',        // Tipo donut
            data: dataUsers,
            options: {
                responsive: true,
                cutout: '50%',        // Tamaño del hueco central
                plugins: {
                    legend: { position: 'bottom' },
                    tooltip: { enabled: true }
                }
            }
        };

        const ctx2 = document.getElementById('usersChart').getContext('2d');
        new Chart(ctx2, config2);


        //grafica estadisticas descargas y visitas de aritculos
        const articlesByYear = {$articlesByYear|json_encode};

        // Extraemos los labels (meses) y los datos
        const labels = articlesByYear.map(item => {
            const monthStr = item.month.toString();       // "202501"
            const month = monthStr.slice(4, 6);          // "01"
            return month;
        });
        const totalInvestigations = articlesByYear.map(item => item.total_investigations);
        const totalRequests = articlesByYear.map(item => item.total_requests);

        const dataArticlesStatistics = {
            labels: labels,
            datasets: [
                {
                    label: 'Visitas',
                    data: totalInvestigations,
                    backgroundColor: 'rgba(54, 162, 235, 0.7)',
                    borderColor: 'rgba(54, 162, 235, 1)',
                    borderWidth: 1
                },
                {
                    label: 'Descargas',
                    data: totalRequests,
                    backgroundColor: 'rgba(255, 99, 132, 0.7)',
                    borderColor: 'rgba(255, 99, 132, 1)',
                    borderWidth: 1
                }
            ]
        }

        const config3 = {
            type: 'bar',
            data: dataArticlesStatistics,
            options: {
                responsive: true,
                plugins: {
                    legend: { position: 'top' },
                    title: {
                        display: true,
                        text: 'Estadísticas de Visitas y Descargas por Mes'
                    }
                },
                scales: {
                    y: {
                        beginAtZero: true,
                        title: { display: true, text: 'Visitas' }
                    },
                    x: {
                        title: { display: true, text: 'Mes (MM)' }
                    }
                }
            }
        };



        const ctx3 = document.getElementById('articleStatisticsChart').getContext('2d');
        new Chart(ctx3, config3);



    });
</script>
{* Extiende la plantilla frontal de OJS *}
{include file="frontend/components/header.tpl" pageTitle="plugins.generic.stametrics.displayName"}



{* Define el bloque donde irá tu contenido *}
<div class="page page_announcement">

    {include file="frontend/components/breadcrumbs.tpl" currentTitleKey="plugins.generic.stametrics.displayName"}

        <div class="row">
            <div class="col-md-12">

                <div>
                    <p class="h2 mb-4">Métricas editoriales {$year}</p>

                    <!-- Formulario Bootstrap -->
                    <form method="get" action="" class="row g-3 align-items-center mb-4">
                        <div class="col-auto">
                            <label for="year" class="col-form-label">Seleccionar año:</label>
                        </div>
                        <div class="col-auto">
                            <input
                                    type="number"
                                    id="year"
                                    name="year"
                                    value="{$year}"
                                    min="1982"
                                    max="2100"
                                    class="form-control"
                            >
                        </div>
                        <div class="col-auto">
                            <button type="submit" class="btn btn-primary">
                                <i class="bi bi-arrow-repeat"></i> Actualizar
                            </button>
                        </div>
                    </form>


                    <div class="card shadow-sm p-3">
                        <div class="row">
                            <!-- Columna izquierda: Tabla -->
                            <div class="col-md-6 mb-3 mb-md-0">
                                <p class="h4 mb-3">Estado de los envíos</p>
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
                                <canvas id="myChart" width="400" height="300"></canvas>
                            </div>
                        </div>
                    </div>



                    <div class="card shadow-sm p-3 mt-5">
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
                    </div>


                </div>

            </div>
        </div>



    <hr><hr>
    <div class="card">
        <!-- Canvas para la gráfica -->
        <canvas id="articleStatisticsChart" width="800" height="400"></canvas>
        <pre>
        {$articlesByYear|@print_r}
        </pre>
    </div>
    <div class="card">


        <div class="card-body card-columns">

            <ul>
                {foreach from=$users item=user}
                    <li>{$user.username} - {$user.email}</li>
                {/foreach}
            </ul>

        </div>
    </div>

</div>

{include file="frontend/components/footer.tpl"}





