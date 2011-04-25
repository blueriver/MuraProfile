<!---
   Copyright 2011 Blue River Interactive

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
--->
<cfcomponent extends="mura.plugin.pluginGenericEventHandler">

<cffunction name="onApplicationLoad"> 
<cfargument name="$"> 

<cfset variables.profileService=createObject("component","#variables.pluginConfig.getPackage()#.lib.profileService").init()> 
<cfset variables.pApp=variables.pluginConfig.getApplication(purge=true)> 
<cfset variables.pApp.setValue("profileService",variables.profileService)> 

<cfset variables.configBean = getServiceFactory().getBean('configBean')>
<cfset variables.contentManager = getServiceFactory().getBean('contentManager')>
<cfset variables.settingsManager = getServiceFactory().getBean('settingsManager')>
<cfset variables.pluginConfig.setSetting("pluginPath","#variables.configBean.getContext()#/plugins/#variables.pluginConfig.getDirectory()#/")/>
		
 <!--- By pulling out the profileService from the pluginApplication object 
autowiring is performed---> 
<cfset variables.profileService=pApp.getValue("profileService")> 
<cfif isdefined("session.mura")>
	 <cfset variables.profileService.buildRequirements($)> 
</cfif>
<cfset variables.pluginConfig.addEventHandler(this)> 
</cffunction> 

<cffunction name="onSiteLoginSuccess" output="false"> 
<cfargument name="$"> 
 <cfset $.event('userBean',$.currentUser())> 
 <cfset variables.profileService.buildProfile($)> 
</cffunction> 

<cffunction name="onAfterUserSave" output="false"> 
<cfargument name="$"> 

 <cfset variables.profileService.buildProfile($)> 
</cffunction> 

<cffunction name="onAfterUserDelete" output="false"> 
<cfargument name="$"> 
 <cfset variables.profileService.deleteProfile($)> 
</cffunction> 

<cffunction name="onSite404" output="false"> 
<cfargument name="$"> 
 <cfset variables.profileService.lookUpProfile($)> 
</cffunction> 

<cffunction name="onPortalProfileBodyRender" output="true" returntype="void">
	<cfargument name="$">
	<cfset var local=structNew()>
	<cfset local.profileUser=$.getBean("user").loadBy(userID=$.content("remoteID"))>
	<cfif not len($.event("profile.mode"))>
	<cfoutput>
	<cfif $.currentUser("userID") eq $.content("remoteID")>
		<h3>Hello #HTMLEditFormat(local.profileUser.getFname() & " " & local.profileUser.getLname())#</h3>
	<cfelse>
		<h3>Welcome to  #HTMLEditFormat(local.profileUser.getFname() & " " & local.profileUser.getLname())#'s Profile</h3>
	</cfif>
	</cfoutput>
	</cfif>
	<cfinclude template="../display_objects/profile/index.cfm">
</cffunction>

<cffunction name="onPagePostBodyRender" output="true" returntype="void">
	<cfargument name="$">
	<cfset var local=structNew()>	
	<cfset local.profileUser=$.getBean("user").loadBy(contentID=$.content("remoteSource"))>
	<cfinclude template="../display_objects/profile/index.cfm">
</cffunction>

</cfcomponent>