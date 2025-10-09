{* stametrics_main.tpl *}
{include file="frontend/components/header.tpl" pageTitle="plugins.generic.stametrics.displayName"}

<script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

<style>
    /* Botones cuadrados negros con texto amarillo al activo */
    .btn-tab {
        background-color: black;
        color: white;
        border-radius: 0;
    }
    .btn-tab.active {
        color: yellow;
    }
</style>

<div class="page page_announcement">
    {include file="frontend/components/breadcrumbs.tpl" currentTitleKey="plugins.generic.stametrics.displayName"}

    <div class="mt-4">
        {* Barra de botones para cambiar de pestaña *}
        <div class="mb-4 d-flex gap-2">
            <button class="btn btn-tab {if $currentTab == 'articles'}active{/if}" data-target="#articlesTab">Artículos</button>
            <button class="btn btn-tab {if $currentTab == 'submissions'}active{/if}" data-target="#submissionsTab">Envíos</button>
            <button class="btn btn-tab {if $currentTab == 'users'}active{/if}" data-target="#usersTab">Usuarios</button>
        </div>

        {* Formulario de año para las pestañas que lo usan *}
        {if $currentTab != 'users'}
            <form method="get" action="" class="row g-3 align-items-center mb-4">
                <input type="hidden" name="tab" value="{$currentTab}">
                <div class="col-auto">
                    <label for="year" class="col-form-label">Seleccionar año:</label>
                </div>
                <div class="col-auto">
                    <input type="number" id="year" name="year" value="{$year}" min="1982" max="2100" class="form-control">
                </div>
                <div class="col-auto">
                    <button type="submit" class="btn btn-primary">
                        <i class="bi bi-arrow-repeat"></i> Actualizar
                    </button>
                </div>
            </form>
        {/if}

        {* Contenedores de contenido por pestaña *}
        <div class="tab-content">
            <div id="articlesTab" class="tab-pane {if $currentTab == 'articles'}active{/if}">
                {* Estadísticas de artículos *}
                <div class="card mb-4">
                    <canvas id="articleStatisticsChart" width="800" height="400"></canvas>
                </div>
            </div>

            <div id="submissionsTab" class="tab-pane {if $currentTab == 'submissions'}active{/if}">
                {* Estadísticas de envíos *}
                <div class="card shadow-sm p-3 mb-4">
                    <div class="row">
                        <div class="col-md-6">
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

                        <div class="col-md-6 d-flex align-items-center">
                            <canvas id="myChart" width="400" height="300"></canvas>
                        </div>
                    </div>
                </div>
            </div>

            <div id="usersTab" class="tab-pane {if $currentTab == 'users'}active{/if}">
                {* Estadísticas de usuarios *}
                <div class="card shadow-sm p-3 mb-4">
                    <div class="row">
                        <div class="col-md-6">
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

                        <div class="col-md-6 d-flex align-items-center">
                            <canvas id="usersChart" width="400" height="300"></canvas>
                        </div>
                    </div>
                </div>
            </div>
        </div>

    </div>
</div>

<script>
    $(document).ready(function() {
        // Mantener pestaña activa y cambiar contenido
        $('.btn-tab').click(function(e) {
            e.preventDefault();
            $('.btn-tab').removeClass('active');
            $(this).addClass('active');

            $('.tab-pane').removeClass('active');
            $($(this).data('target')).addClass('active');
        });



        // Chart.js para artículos
        const articlesByYear = {$articlesByYear|json_encode};
        const labels = articlesByYear.map(item => item.month.toString().slice(4,6));
        const totalInvestigations = articlesByYear.map(item => item.total_investigations);
        const totalRequests = articlesByYear.map(item => item.total_requests);

        const ctxArticles = document.getElementById('articleStatisticsChart').getContext('2d');
        new Chart(ctxArticles, {
            type: 'bar',
            data: {
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
            },
            options: {
                responsive: true,
                plugins: { legend: { position: 'top' }, title: { display: true, text: 'Estadísticas de Visitas y Descargas por Mes' }},
                scales: {
                    y: { beginAtZero: true, title: { display: true, text: 'Visitas' }},
                    x: { title: { display: true, text: 'Mes (MM)' }}
                }
            }
        });

        // Chart.js para envíos
        const dataSubmissions = {$submissions|json_encode};
        const ctxSubmissions = document.getElementById('myChart').getContext('2d');
        new Chart(ctxSubmissions, {
            type: 'bar',
            data: {
                labels: ['Recibidos', 'En cola', 'Publicados', 'Rechazados'],
                datasets: [{
                    label: 'Número de envíos',
                    data: [dataSubmissions.received, dataSubmissions.queued, dataSubmissions.published, dataSubmissions.declined],
                    backgroundColor: ['rgba(13,110,253,0.5)','rgba(108,117,125,0.5)','rgba(25,135,84,0.5)','rgba(220,53,69,0.5)'],
                    borderColor: ['rgba(13,110,253,1)','rgba(108,117,125,1)','rgba(25,135,84,1)','rgba(220,53,69,1)'],
                    borderWidth: 1
                }]
            },
            options: { responsive: true, scales: { y: { beginAtZero: true } } }
        });

        // Chart.js para usuarios
        const ctxUsers = document.getElementById('usersChart').getContext('2d');
        new Chart(ctxUsers, {
            type: 'doughnut',
            data: {
                labels: ['Autores', 'Revisores', 'Lectores'],
                datasets: [{
                    label: 'Número de envíos',
                    data: [{$userCountAuthor}, {$userCountReviewer}, {$userCountReader}],
                    backgroundColor: ['rgba(253,97,13,0.5)','rgba(248,209,23,0.5)','rgba(108,117,125,0.5)'],
                    borderColor: ['rgba(253,97,13,1)','rgba(248,209,23,1)','rgba(108,117,125,1)'],
                    borderWidth: 1
                }]
            },
            options: { responsive: true, cutout: '50%', plugins: { legend: { position: 'bottom' } } }
        });
    });
</script>

{include file="frontend/components/footer.tpl"}
