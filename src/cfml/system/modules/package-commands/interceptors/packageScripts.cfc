/**
*********************************************************************************
* Copyright Since 2014 CommandBox by Ortus Solutions, Corp
* www.coldbox.org | www.ortussolutions.com
********************************************************************************
* @author Brad Wood
*
* I am an interceptor that listens to all the interception points and runs package scripts for them if they exist.
*
*/
component {
	property name="packageService"		inject="packageService";
	property name="shell"				inject="shell";
	property name='consoleLogger'		inject='logbox:logger:console';
	
	function onCLIStart() { processScripts( 'onCLIStart' ); }
	function onCLIExit() { processScripts( 'onCLIExit' ); }
	function preCommand() { processScripts( 'preCommand' ); }
	function postCommand() { processScripts( 'postCommand' ); }
	function preModuleLoad() { processScripts( 'preModuleLoad' ); }
	function postModuleLoad() { processScripts( 'postModuleLoad' ); }
	function preModuleUnLoad() { processScripts( 'preModuleUnLoad' ); }
	function postModuleUnload() { processScripts( 'postModuleUnload' ); }
	function onServerStart() { processScripts( 'onServerStart', interceptData.serverinfo.webroot ); }
	function onServerStop() { processScripts( 'onServerStop', interceptData.serverinfo.webroot ); }
	function onException() { processScripts( 'onException' ); }
	function preInstall() { processScripts( 'preInstall' ); }
	function postInstall() { processScripts( 'postInstall' ); }
	function preUninstall() { processScripts( 'preUninstall' ); }
	function postUninstall() { processScripts( 'postUninstall' ); }
	function preVersion() { processScripts( 'preVersion' ); }
	function postVersion() { processScripts( 'postVersion' ); }
	function prePublish() { processScripts( 'prePublish' ); }
	function postPublish() { processScripts( 'postPublish' ); }
	
	function processScripts( required string interceptionPoint, string directory=shell.pwd() ) {
		// Read the box.json from this package (if it exists)
		var boxJSON = packageService.readPackageDescriptor( arguments.directory );
		// If there is a scripts object with a matching key for this interceptor....
		if( boxJSON.keyExists( 'scripts' ) && isStruct( boxJSON.scripts ) && boxJSON.scripts.keyExists( interceptionPoint ) ) {
			var thisScript = boxJSON.scripts[ interceptionPoint ];
			
			consoleLogger.debug( "." );
			consoleLogger.warn( 'Running #interceptionPoint# package script.' );
			consoleLogger.debug( '> ' & thisScript );
			
			// ... then run the script! (in the context of the package's working directory)
			var previousCWD = shell.pwd();
			shell.cd( arguments.directory );
			shell.callCommand( thisScript );
			shell.cd( previousCWD );
		}
	}
		
}