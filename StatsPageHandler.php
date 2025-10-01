<?php

namespace APP\plugins\generic\stametrics;

use APP\API\v1\stats\editorial\StatsEditorialController;
use APP\core\Application;
use APP\facades\Repo;
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

        $userService = new UserService();

        // Pasar al template
        $templateMgr->assign('users', $userService->getUsers($context));
        $templateMgr->assign('userCount', $userService->countUsers($context));
        $templateMgr->assign('userCountAuthor', $userService->countUsersByRole($context, \Role::ROLE_ID_AUTHOR));
        $templateMgr->assign('userCountReviewer', $userService->countUsersByRole($context, \Role::ROLE_ID_REVIEWER));
        $templateMgr->assign('userCountReader', $userService->countUsersByRole($context, \Role::ROLE_ID_READER));

        $submissionService = new SubmissionService();
        $result = $submissionService->getEditorialStatsByYear($context,2025);



        return $templateMgr->display($this->plugin->getTemplateResource('stats.tpl'));
    }
}
