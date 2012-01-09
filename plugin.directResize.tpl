//<?php
/**
 * DirectResize
 * 
 * Automatic thumbnails creation and watermarking.
 *
 * @category 	plugin
 * @version 	0.8.0.2
 * @license 	http://www.gnu.org/copyleft/gpl.html GNU Public License (GPL)
 * @internal    @properties &config=Configuration;string;highslide &clearCache=Cache clear mode;list;0,1,2;0
 * @internal	@events OnWebPagePrerender,OnCacheUpdate,OnBeforeDocFormSave,OnDocFormPrerender
 * @internal	@modx_category Content
*/

define(DIRECTRESIZE_PATH, "assets/plugins/directresize/");
define(DIRECTRESIZE_GALLERYDIR, "assets/drgalleries/");
include_once $modx->config['base_path'].DIRECTRESIZE_PATH."directResize.php";

global $content;
		
$e = &$modx->Event;
switch ($e->name) {
  case "OnBeforeDocFormSave":
  		$content = ConvertFromBackend($_POST['ta']);
  		//if (isset($_POST[which_editor]) && $_POST[which_editor]!="none" && strlen($_POST['ta'])>0) $content['content']  = ConvertFromBackend($_POST['ta'], false);
    break;
    
	case "OnWebPagePrerender":
			//$modx->documentObject[content] = RenderOnFrontend($modx->documentObject[content], $config);
			$modx->documentOutput = RenderOnFrontend($modx->documentOutput, $config);
	break;
		
	case "OnDocFormPrerender":
		// Плагин инициируется только в визуальном редакторе. Без редактора замены больших картинок на превью нет
		if (($modx->config[which_editor] != "none" && empty($_POST)) || (isset($_POST[which_editor]) && $_POST[which_editor]!="none"))
		{		
			$content['content'] = RenderOnFrontend($content['content'], $config);
		}
		else
		{
			if (strlen($_POST['ta'])>0)  $content['content']  = ConvertFromBackend($_POST['ta'], false);
		}
	break;

	case "OnCacheUpdate":
			ClearDRCache($clearCache);
	break;	
	
	default :
		return;
	break;
}