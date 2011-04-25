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
<cfoutput>
<link href="#variables.pluginConfig.getSetting('pluginPath')#display_objects/css/profile.css" rel="stylesheet" type="text/css" /></cfoutput>
<cfif $.event("r").perm eq "editor" 
	or 
	($.currentUser().isLoggedIn()
		and
			(
				$.content("remoteID") eq $.currentUser("userID") 
				or $.content("remoteSource") eq $.currentUser("userID")
			)
	)>
	<cfset local.editable=true>
<cfelse>
	<cfset local.editable=false>
</cfif>
<cfif listFindNoCase("inlineadd,inlineedit,save,delete",$.event('profile.mode'))
and local.editable>
<cfswitch expression="#$.event('profile.mode')#">
	<cfcase value="inlineadd">
		<cfset local.contentBean = $.getBean("content")>
		<h4>Add Post</h4>
		<cfinclude template="dsp_editForm.cfm">
	</cfcase>
	<cfcase value="inlineedit">
		<cfset local.contentBean = $.content()>
		<h4>Edit Post</h4>
		<cfinclude template="dsp_editForm.cfm">
	</cfcase>
	<cfcase value="save">
		<cfset local.contentBean = variables.profileService.savePost($)>
		<cflocation url="#local.contentBean.getURL()#">
	</cfcase>
	<cfcase value="delete">
		<cfset local.contentBean = profileService.deletePost($)>
		<cflocation url="#$.getParent().getURL()#">
	</cfcase>
</cfswitch>
<cfelse>
	<cfset local.contentBean = $.content()>
	<cfinclude template="dsp_default.cfm">
</cfif>