
var xmlhttp, ADDED_MATERILAS_COUNT = 0;
initialize_ajax_object();
addEventListnersz();

function addMaterialClick(element) {
	var materialId = parseInt(element.getAttribute("data-id"));

	if( inAddedMaterials(materialId, 0) ) {
		addStudyMaterial(materialId, element);
	}
	else {
		$(this).html("Already added this material.");
	}

	$(element).remove();
}

function searchFunction() {
	var str = $(".search").val();

	if ( str.length > 2) {

		//sending ajax request
		xmlhttp.open("GET","/study_materials/search?search="+str,false);
		xmlhttp.send();

		//getting the response as json and parsing it
		var parsedResults = $.parseJSON(xmlhttp.responseText);

		//clearing the count to display the index of results && clearing the flag
		var count = 1;
		var flag = 0;

		//emptying the contents of the results box
		$(".searchresults").empty();

		$.each(parsedResults, function(index, element) {

			if ( inAddedMaterials(element.id, 0) ) {	
				showSingleResult(count, element);
				count++;
				flag = 1;
			}
			else if ( flag == 0) {
				flag = 2;
			}

    		console.log((index+1) + "." +element.title + " ID : " + element.id); 
		});
		
		( flag == 0 ? displayMsg(1) : (flag == 2? displayMsg(2)  : false ) );
	}

	else {
		displayMsg(0);
	}

	console.log("flag : " + flag);
	//document.getElementById("").innerHTML=xmlhttp.responseText;
}


function inAddedMaterials(id, flag) {
	if (($('#material_ids').val() == undefined) && (flag == 1)) {
		return [];
	}
	var addedMaterials = $('#material_ids').val().split(",").map(Number);
	//var arrayOfNumbers = ["1", "2", "3"].map(Number);
	if( flag == 0 ) {
		return (($.inArray( id, addedMaterials) == -1) ? true : false) ;
	} else {
		return addedMaterials;
	}
}

function showSingleResult( index, obj) {

	li = document.createElement('li');
	$(li).addClass("list-group-item");

	$(generateRow( index, obj.title) ).appendTo(li);

	$(li).click( function() { addMaterialClick(this); });
	$(li).attr("data-id", obj.id );
	$(li).attr("data-title", obj.title );

	$(li).appendTo($(".searchresults"));
}

function initialize_ajax_object() {

	if (window.XMLHttpRequest) {
		// code for IE7+, Firefox, Chrome, Opera, Safari
  		xmlhttp = new XMLHttpRequest();
  	}
	else {
		// code for IE6, IE5
  		xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
  	}
}

function displayMsg( num) {

	var msgs = [ "Type atleast 3 characters and we will list the matching results.",
				 "Sorry no matching results were found.",
				 "You have already added the matching results as study materials. Nothing more to display." ];


	//emptying the contents of the results box
	$(".searchresults").empty();

	li = document.createElement('li');
	$(li).html(msgs[num]);
	$(li).addClass("list-group-item");
	$(li).appendTo($(".searchresults"));

	console.log(msgs[0]);
}

function addStudyMaterial(materialId, slectedElement) {

	//get the already added materials id 
	var materials = inAddedMaterials(0, 1);

	if ( materials.indexOf(0) != -1)
		{ materials.splice(materials.indexOf(0), 1); }

	//add the new material to it
	materials.push(materialId);

	//change the hidden input attribute value to new value
	$("#material_ids").val(materials);

	//list the study materials as added
	li = document.createElement('li');
	if (ADDED_MATERILAS_COUNT == 0) { 
		$(".added-materials").empty();
	}	
	var row = generateRow( ++ADDED_MATERILAS_COUNT, slectedElement.getAttribute("data-title"));
	row = generateRowWithClose(materialId, row);
	$(row).appendTo(li);
	$(li).addClass("list-group-item study-material-id-"+materialId);
	$(li).appendTo($(".added-materials"));

}

function generateRow( count, content) {

	row = document.createElement('div');
	$(row).addClass("row");

		// col1 = document.createElement('div');
		// $(col1).addClass("col-md-1");
		// $(col1).html(count);

		col2 = document.createElement('div');
		$(col2).addClass("col-md-10");
		$(col2).html(content);

	// $(col1).appendTo(row);
	$(col2).appendTo(row);

	return row;
}

function generateRowWithClose(materialId, row) {

	var col3 = document.createElement('div');
	$(col3).addClass("col-md-1");

		var span = document.createElement('span');
		$(span).addClass("glyphicon glyphicon-remove remove-material");
		$(span).attr("data-material", materialId );
		$(span).click( function() { removeMaterial(this); });

	$(span).appendTo(col3);	
	$(col3).appendTo(row);
	return row;
}

function addEventListnersz() {

	$('.drop-course').click( function() { dropCourse( this ); });
	$('.activate-course').click( function() { activateCourse(this); });
	$('.enroll-me').click( function() { enrollMe(this); });
	$('.finished-material').click( function() { finishedCurrentMaterial(this); });
	$('.suggest').click( function() { suggestCourse(this); });
	$('.rate-button').click( function() { rating(); });

	$( "#target" ).submit(function( event ) {
  		suggestCourse(event);
  		return false;
	});
	// $('.remove-material').forEach(function(value){
	// 	$(value).click( function() { removeMaterial(this); });
	// });
	
	var rm = $('.remove-material');
	for( var i = 0; i < rm.length ; ++i ){
		$(rm[i]).click( function() { removeMaterial(this); });
	}

	if( inAddedMaterials(0,1)[0] != 0) {
		ADDED_MATERILAS_COUNT = inAddedMaterials(0, 1).length;
	}
	
}

function dropCourse(element) {
	
	var lpId = element.getAttribute("data-lp");
	//sending ajax request
	xmlhttp.open("GET","/learning_processes/drop_course?lp_id="+lpId,false);
	xmlhttp.send();
	if ( xmlhttp.responseText == "Success"){
			msg = "Successfully dropped the course.";
			dspCourseMsg(msg);
			reload();
	} else {
			msg = "Could not drop the course."+xmlhttp.responseText;
			dspCourseMsg(msg);
	}	
	console.log("in drop course. : "+lpId);
}

function activateCourse(element) {
	var lpId = element.getAttribute("data-lp");
	//sending ajax request
	xmlhttp.open("GET","/learning_processes/activate_course?lp_id="+lpId,false);
	xmlhttp.send();
	if ( xmlhttp.responseText == "Success") {
			msg = "Successfully activated the course.";
			dspCourseMsg(msg);
			reload();
	} else {
			msg = "Could not activate the course.";
			dspCourseMsg(msg);
	}	
	console.log("in activate course. : "+lpId);
}

function enrollMe(element) {
	var courseId = element.getAttribute("data-course");
	//sending ajax request
	xmlhttp.open("GET","/learning_processes/enroll_me?course_id="+courseId,false);
	xmlhttp.send();
	if ( xmlhttp.responseText == "Success") {
			msg = "Successfully enrolled for the course.";
			dspCourseMsg(msg);
			reload();
	} else {
			msg = "Could not enroll for the course.["+xmlhttp.responseText+"]";
			dspCourseMsg(msg);
	}	
	console.log("in enroll course. : "+courseId);
}

function finishedCurrentMaterial(element) {
	var lpId = element.getAttribute("data-lp");
	//sending ajax request
	xmlhttp.open("GET","/learning_processes/finished_material?lp_id="+lpId,false);
	xmlhttp.send();
	if ( xmlhttp.responseText == "Success") {
			reload();
	} else {
			msg = "Could not update that request of you finishing the current study material."+xmlhttp.responseText;
			dspCourseMsg(msg);
	}	
	console.log("in finishedCurrentMaterial course." + lpId + "## "+ xmlhttp.responseText);
}

function suggestCourse(element) {
	var courseId = $(".suggest-input").attr("data-course");
	var emails = $(".suggest-input").val().split(",").map(removeTrail);

	var success = "";
	var failure = "";

	emails.forEach(function(mail) {
		if (IsEmail(mail)) {
			xmlhttp.open("GET","/learning_processes/suggest?email="+mail+"&course="+courseId, false);
			xmlhttp.send();

			if ( xmlhttp.responseText == "Success") {
				success += mail+" ,";
			} else {
				failure += mail+ "[" + xmlhttp.responseText +"] , ";
			}
		} else {
			failure += mail+ "[Invalid email] ,";
		}	
    		console.log(mail + " ## Course id : "+courseId);
	});

	if (success.length > 3) {
		dspCourseMsg("Succesfully enrolled "+success+" to this course.");
	}
	if  (failure.length > 3) {
		dspCourseMsg("Could not enroll "+failure+" to this course.")
	}
	
	console.log("in finishedCurrentMaterial course." + emails);	
}

function reload() {
	setTimeout(function(){
  					 location.reload(true);
			}, 1500);
}

function dspCourseMsg(msg){

	if ($(".alert-info").length != 0 ){
		$(".alert-info").html(msg);
		$(".alert-info").click( function(){ $(".alert-info").remove();});
	}else{
		alert_msg = document.createElement('div');
		$(alert_msg).addClass("alert alert-info");
		$(alert_msg).html(msg);
		$(alert_msg).appendTo($(".course-status-bar"));
		$(alert_msg).click( function(){ $(this).remove();});	
	}
}

function removeTrail(value, index, obj) {
	return value.trim();
}

function IsEmail(email) {
  	var regex = /^([a-zA-Z0-9_.+-])+\@(([a-zA-Z0-9-])+\.)+([a-zA-Z0-9]{2,4})+$/;
  	return regex.test(email);
}

function removeMaterial(element) {
	
	var materialId = parseInt($(element).attr("data-material"));

	if( !inAddedMaterials(materialId, 0) ) {
		console.log("inside processing");
		//get the already added materials id 
		var materials = inAddedMaterials(0, 1);
		console.log(materials);
		ADDED_MATERILAS_COUNT -= 1;
		if ( materials.indexOf(materialId) != -1)
			{ materials.splice(materials.indexOf(materialId), 1); }

		if ( materials.indexOf(0) != -1)
			{ materials.splice(materials.indexOf(0), 1); }

		console.log(materials);
		//change the hidden input attribute value to new value
		$("#material_ids").val(materials);
	}
	console.log("remove the lement"+materials);
	$(".study-material-id-"+materialId).remove();
}

function rating() {
	var course = parseInt($(".rating-input").attr("data-course"));
	var user_rating = parseInt($(".rating-input").val());
	//return true;
	xmlhttp.open("GET","/learning_processes/rate_course?rating="+user_rating+"&course="+course,false);
	xmlhttp.send();
	if ( xmlhttp.responseText == "Success") {
			msg = "Successfully rated the course.";
			dspCourseMsg(msg);
			reload();
	} else {
			msg = "Could not rate the course."+xmlhttp.responseText;
			dspCourseMsg(msg);
	}	
	console.log("in rate course. course: "+ course + " rating : " +user_rating);
	//reload();
}