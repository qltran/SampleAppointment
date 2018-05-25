$(function() {
    $("#btnSearch").click(getAppointments);
	$("#btnNew").click(visibleAddAppointment);
	$("#btnCancel").click(hideAddAppointment);
	
	if ($('#tblAppointments tr').length > 0) {
		$('#tblAppointments').removeClass("not");
	}
});

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
	return day + ' ' + months[midx] + ' ' + year;
}