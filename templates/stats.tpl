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
                        <h5 class="card-title">Ejemplo de contenido</h5>
                        <p class="card-text">Tu contenido aquí con todos los estilos de OJS.</p>
                    </div>
                </div>
            </div>
        </div>


</div>

{include file="frontend/components/footer.tpl"}