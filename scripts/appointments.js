$(function() {
    $("#btnSearch").click(getAppointments);
	$("#btnNew").click(visibleAddAppointment);
	$("#btnCancel").click(hideAddAppointment);
	
	if ($('#tblAppointments tr').length > 1) {
		$('#tblAppointments').removeClass("not");
	}
	
	// Do validation before submit form
	$( "#appointmentForm" ).submit(function( event ) {
		if (!checkDate()){
			event.preventDefault();
		} else {
			$( "#appointmentForm" ).submit();
		}
	});
});

function checkDate() {
	var selectedText = $("input[name*='date']").val() + ' ' + $("input[name*='time']").val();
	var selectedDate = new Date(selectedText);
	var now = new Date();
	if (selectedDate < now) {
		$("#error").empty();
		$("<label>").text('Appointment time should be in the future!').addClass("error").appendTo($("#error"));
		return false;
	}
	return true;
 }

function visibleAddAppointment(){
	$("#divNew").addClass("not");
	$("#appointmentForm").removeClass("not");
}

function hideAddAppointment(){
	$("#divNew").removeClass("not");
	$("#appointmentForm").addClass("not");
}

function getAppointments(){
	$("#tblAppointments").removeClass("not");
	$.ajax({
		"dataType": "json",
		"mimeType": "application/json",
        "url": "http://localhost:8080/search",
        "data": {"criteria": $("#criteria").val()},
        "type": "GET",
        "success": displayAppointments,
        "error": displayFailure
    });
}

function displayAppointments(response) {
	console.log(response);
	$("#tblAppointments").find("tr:gt(0)").remove();
	$.each(response.appointments, function (i, item) {
		var datetime = new Date(item.time);
		var $tr = $('<tr>').append(
            $('<td>').text(formatDate(datetime)),
            $('<td>').text(datetime.toLocaleString('en-US', { hour: 'numeric', minute: 'numeric', hour12: true })),
            $('<td>').text(item.description)
        ).appendTo('#tblAppointments');
	});
	
}

function displayFailure(xhr, status, exception) {
	console.log(xhr, status, exception);
}

function formatDate(date) {
	var months = [
		"January", "February", "March",
		"April", "May", "June", "July",
		"August", "September", "October",
		"November", "December"
	];

	var day = date.getDate();
	var midx = date.getMonth();
	var year = date.getFullYear();
	return months[midx] + ' ' + day + ' ' + year;
}