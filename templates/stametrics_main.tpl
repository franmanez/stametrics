<script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

{include file="frontend/components/header.tpl" pageTitle="plugins.generic.stametrics.displayName"}

<div class="page page_announcement">

    {include file="frontend/components/breadcrumbs.tpl" currentTitleKey="plugins.generic.stametrics.displayName"}

    <div class="mt-4">

        <!-- Navbar para cambiar entre pantallas -->
        <div class="mb-4 d-flex gap-2">
            <a href="stametrics?tab=articles&year={$year}" class="btn rounded-0 btn-dark {if $currentTab == 'articles'}active{/if}">Artículos</a>
            <a href="stametrics?tab=submissions&year={$year}" class="btn rounded-0 btn-dark {if $currentTab == 'submissions'}active{/if}">Envíos</a>
            <a href="stametrics?tab=users&year={$year}" class="btn rounded-0 btn-dark {if $currentTab == 'users'}active{/if}">Usuarios</a>
        </div>
        <ul class="nav nav-pills nav-fill mb-4">
            <li class="nav-item">
                <a class="nav-link {if $currentTab == 'articles'}active{/if}" href="stametrics?tab=articles&year={$year}">Artículos</a>
            </li>
            <li class="nav-item">
                <a class="nav-link {if $currentTab == 'submissions'}active{/if}" href="stametrics?tab=submissions&year={$year}">Envíos</a>
            </li>
            <li class="nav-item">
                <a class="nav-link {if $currentTab == 'users'}active{/if}" href="stametrics?tab=users&year={$year}">Usuarios</a>
            </li>
        </ul>

        {if $currentTab != 'users'}
        <!-- Formulario -->
        <form method="get" action="" class="row g-3 align-items-center mb-4">
            <input type="hidden" name="tab" value="{$currentTab}">
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
        {/if}
        <!-- Contenido dinámico según pestaña -->


        <!-- Contenedor donde se cargará el contenido dinámicamente -->
        <div id="tabContent">
            {include file="file:plugins/generic/stametrics/templates/stametrics_`$currentTab`.tpl"}
        </div>

    </div>
</div>

<style>
    .btn.active {
        color: yellow !important;
    }
</style>

<script>
    $(document).ready(function() {

        function loadTab(url) {
            $.get(url, { ajax: 1 }, function(data) {
                $('#tabContent').html(data);

                // Actualizar botón activo
                $('.btn-tab').removeClass('active');
                $('.btn-tab[href="' + url + '"]').addClass('active');
            });
        }

        // Click en botones de tab
        $('.btn-tab').on('click', function(e) {
            e.preventDefault();
            const url = $(this).attr('href');
            alert("asd");
            loadTab(url);
            history.pushState(null, '', url); // Actualiza la URL sin recargar
        });

        // Manejar cambio de año
        $('#yearForm').on('submit', function(e) {
            e.preventDefault();
            const year = $('#year').val();
            const activeTab = $('.btn-tab.active').attr('href').split('?')[0];
            loadTab(activeTab + '?year=' + year);
        });

        // Manejo de back/forward del navegador
        window.onpopstate = function() {
            loadTab(location.pathname + location.search);
        };
    });
</script>

{include file="frontend/components/footer.tpl"}