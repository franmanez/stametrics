{* stats.tpl *}

{* Extiende la plantilla frontal de OJS *}
{include file="frontend/components/header.tpl" pageTitle="plugins.generic.stametrics.displayName"}

{* Define el bloque donde irá tu contenido *}
<div class="page page_announcement">

    {include file="frontend/components/breadcrumbs.tpl" currentTitleKey="plugins.generic.statisticsUPC.name"}

        <div class="row">
            <div class="col-md-12">
                <h1>Mis Estadísticas</h1>
                <p>Este es tu contenido personalizado que aparecerá dentro del layout de OJS.</p>

                <div class="card">
                    <div class="card-body">
                        <h1 class="card-title">Usuarios totales: {$userCount}</h1>
                        <h1 class="card-title">Autores: {$userCountAuthor}</h1>
                        <h1 class="card-title">Revisores: {$userCountReviewer}</h1>
                        <h1 class="card-title">Lectores: {$userCountReader}</h1>

                        <ul>
                            {foreach from=$users item=user}
                                <li>{$user.username} - {$user.email}</li>
                            {/foreach}
                        </ul>

                    </div>
                </div>
            </div>
        </div>


</div>

{include file="frontend/components/footer.tpl"}