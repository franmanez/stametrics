<?php

namespace APP\plugins\generic\stametrics;

use APP\template\TemplateManager;
use PKP\controllers\page\PageHandler;

class StatsPageHandler extends PageHandler
{
    public StametricsPlugin $plugin;

    public function __construct(StametricsPlugin $plugin)
    {
        parent::__construct();
        $this->plugin = $plugin;
    }

    /**
     * Sobrescribe el método authorize para permitir acceso público
     */
    public function authorize($request, &$args, $roleAssignments)
    {
        // No llamamos al parent::authorize() para evitar la verificación de login
        return true;
    }

    public function index($args, $request)
    {
        $templateMgr = TemplateManager::getManager($request);



        return $templateMgr->display($this->plugin->getTemplateResource('stats.tpl'));
    }
}
