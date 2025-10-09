<?php

namespace APP\plugins\generic\stametrics;

use APP\API\v1\stats\editorial\StatsEditorialController;
use APP\core\Application;
use APP\facades\Repo;
use APP\plugins\generic\stametrics\services\ArticleStatisticsService;
use APP\plugins\generic\stametrics\services\SubmissionService;
use APP\plugins\generic\stametrics\services\UserService;
use APP\template\TemplateManager;
use PKP\API\v1\stats\editorial\PKPStatsEditorialController;
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

        $request = Application::get()->getRequest();
        $context = $request->getContext();
        //$journal = $request->getJournal();

        // Solo aquí añades CSS/JS
        $templateMgr->addStylesheet('mi-plugin-bootstrap', 'https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css');
        $templateMgr->addStylesheet('mi-plugin-bootstrap-icons', 'https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css');
        $templateMgr->addJavaScript('mi-plugin-bootstrap', 'https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js');
        $templateMgr->addJavaScript('mi-plugin-jquery', 'https://code.jquery.com/jquery-3.7.0.min.js');



        $year = (int) $request->getUserVar('year');
        if (!$year) {
            $year = date('Y'); // o 2025 por defecto
        }

        // Detectar la tab según el URL
        $currentTab = $_GET['tab'] ?? 'articles';
        $templateMgr->assign('currentTab', $currentTab);

        //$templateMgr->assign('baseUrl', $request->getBaseUrl());

        $userService = new UserService();

        // Pasar al template
        $templateMgr->assign('users', $userService->getUsers($context));
        $templateMgr->assign('userCount', $userService->countUsers($context));
        $templateMgr->assign('userCountAuthor', $userService->countUsersByRole($context, \Role::ROLE_ID_AUTHOR));
        $templateMgr->assign('userCountReviewer', $userService->countUsersByRole($context, \Role::ROLE_ID_REVIEWER));
        $templateMgr->assign('userCountReader', $userService->countUsersByRole($context, \Role::ROLE_ID_READER));

        $submissionService = new SubmissionService();
        $templateMgr->assign('submissions', $submissionService->getEditorialStatsByYear($context, $year));


        $articleStatisticsService = new ArticleStatisticsService();
        $templateMgr->assign('articlesByYear', $articleStatisticsService->getArticleMetricsByYear($context, $year));


        $templateMgr->assign('year', $year);


        return $templateMgr->display($this->plugin->getTemplateResource('stametrics2.tpl'));
    }
}
