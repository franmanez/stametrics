<?php

/**
 * @file plugins/generic/doiBoardUpc/DoiBoardUpcPlugin.php
 *
 * Distributed under The MIT License. For full terms see the file LICENSE.
 * @author Fran Máñez - fran.upc@gmail.com
 *
 * @class DoiBoardUpcPlugin
 *
 * @brief Plugin This plugin adds a link to the article view in OJS. The link directs users to the DOIBoard application by UPC (doi.upc.edu).
 * The DOIBoard application allows users to retrieve information about a given DOI registered in Crossref, by querying Crossref’s public API.
 * In addition, the tool provides details about the DOI prefix, showing information about the institution registered in Crossref under that prefix.
 * In this way, the plugin gives users direct and enriched access to both the article’s metadata and the institutional data associated with its DOI.
 *
 */

namespace APP\plugins\generic\stametrics;

use APP\core\Application;
use APP\template\TemplateManager;
use PKP\plugins\GenericPlugin;
use PKP\plugins\Hook;

class StametricsPlugin extends GenericPlugin
{

    /**
     * @copydoc Plugin::getName()
     */
    public function getName()
    {
        return 'StametricsPlugin';
    }

    /**
     * @copydoc Plugin::getDisplayName()
     */
    public function getDisplayName()
    {
        return __('plugins.generic.stametrics.displayName');
    }

    /**
     * @copydoc Plugin::getDescription()
     */
    public function getDescription()
    {
        return __('plugins.generic.stametrics.description');
    }


    public function register($category, $path, $mainContextId = null)
    {
        // Register the plugin even when it is not enabled
        $success = parent::register($category, $path, $mainContextId);

        if ($success && $this->getEnabled()) {

            $request = Application::get()->getRequest();
            $url = $request->getBaseUrl() . '/' . $this->getPluginPath() . '/css/doiBoardUpcPluginStyle.css';
            $templateMgr = TemplateManager::getManager($request);
            //$templateMgr->addStyleSheet('tutorialExampleStyles', $url, array('contexts' => 'frontend') );

            // Registrar hooks usando Hook::add
            //Hook::add('TemplateManager::display', array($this, 'callbackDisplayTemplate'));

            // Registrar directamente el hook donde quieres insertar el enlace
            //Hook::add('Templates::Article::Main', array($this, 'callbackMenuLink'));
            Hook::add('LoadHandler', [$this, 'callbackPageHandler']);
            Hook::add('Templates::Frontend::Objects::Navigation::Element', array($this, 'callbackMenuLink2'));

        }

        return $success;
    }

    public function callbackMenuLink2($hookName, $args) {
        error_log("🎯 ENTRANDO AL CALLBACK");
        $params = $args[0];
        $smarty = $args[1];
        $output =& $args[2];

        $request = Application::get()->getRequest();
        $journal = $request->getJournal();
        $context = $request->getContext();

        if (!$journal) return false;
        if ($this->getEnabled()) {
            $templateMgr = TemplateManager::getManager($request);

            //$output .= 'MI PLUGIN FUNCIONA';
            $output .= '<li class="nav-item"><a class="nav-link" href="' . $templateMgr->smartyUrl(array('page' => 'stametrics'), $smarty) . '" target="_parent">' . $templateMgr->smartyTranslate(array('key' => 'plugins.generic.stametrics.displayName'), $smarty) . '</a></li>';
        }
        return false;
    }

    /**
     * Route requests for the `example` page to a custom page handler
     */
    public function callbackPageHandler(string $hookName, array $args): bool
    {
        $page =& $args[0];
        $handler =& $args[3];

        if ($this->getEnabled() && $page === 'stametrics') {
            $handler = new StatsPageHandler($this);
            return true;
        }
        return false;
    }

}