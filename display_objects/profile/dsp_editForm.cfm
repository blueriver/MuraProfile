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
<cfset $.loadJSLib()>
<cfset $.addToHTMLHeadQueue("htmlEditor.cfm")>
<cfset local.profileBean = variables.profileService.getCurrentProfile($)>

<cfif $.event('profile.mode') neq "inlineadd">
	<cfset local.formURL = local.contentBean.getURL()>
<cfelse>
	<cfset local.formURL = local.profileBean.getURL()>
</cfif>

<script>
	function submitForm(frm) {
		if (validate(frm)) {
			for (var name in CKEDITOR.instances) {
				CKEDITOR.instances[name].updateElement();
			}
			document.forms.postFrm.submit();
		}	
	}
</script>

<cfoutput>
	<form onsubmit="return validateForm(this);" action="#local.formURL#" method="post" name="postFrm">
		<dl>
			<dt>Title</dt>
			<dd>
				<input type="text" name="title" value="#HTMLEditFormat(local.contentBean.getTitle())#" class="text" size="50" required="true" message="Please enter a title" />
			</dd>
		</dl>
		<dl>
			<dt>Body</dt>
			<dd>
				<textarea id="postBody" name="body" class="htmleditor" cols="200" rows="40">
					#local.contentBean.getBody()#
				</textarea>
			</dd>
			
		</dl>
		<dl>
			<dt>Tags</dt>
			<dd>
				<input type="text" name="tags" value="#HTMLEditFormat(local.contentBean.getTags())#" class="text" />
			</dd>
		</dl>
		
		<a id="saveLink" href="#local.formURL#" onclick="submitForm(document.forms.postFrm); return false;">Publish</a>
		
		<cfif $.event('profile.mode') neq "inlineadd">
			<a id="cancelLink" href="#local.contentBean.getURL()#">Cancel</a>
			<a id="deleteLink" href="#local.contentBean.getURL()#?profile.mode=delete" onclick="return confirm('Delete Post?')">Delete</a>
		<cfelse>
			<a id="cancelLink" href="#local.profileBean.getURL()#">Cancel</a>
		</cfif>
		
		<input type="hidden" name="contentID" value="#local.contentBean.getContentID()#">
		<input type="hidden" name="parentID" value="#local.profileBean.getContentID()#">
		<input type="hidden" name="remoteSource" value="#local.profileBean.getRemoteID()#">
		<input type="hidden" name="type" value="Page">
		<input type="hidden" name="subType" value="Post">
		<input type="hidden" name="credits" value="#HTMLEditFormat(local.profileUser.getFname() & ' ' & local.profileUser.getLname())#">
		<input type="hidden" name="profile.mode" value="save">
	</form>
	<script type="text/javascript"> 
		setHTMLEditors(200,"95%");
	</script>
</cfoutput>