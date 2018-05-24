$(function() {
    $("#btnSearch").click(getAppointments);
});

function getAppointments(){
	$.ajax({
        "url": "http://localhost:8080/search",
        "data": {"criteria": $("#criteria").val()},
        "type": "GET",
        "success": displayAppointments,
        "error": displayFailure
    });
}

function displayAppointments(appointments) {
	$.each(appointments, function (i, item) {
		var datetime = new Date(item.time);
		var $tr = $('<tr>').append(
            $('<td>').text(datetime),
            $('<td>').text(datetime),
            $('<td>').text(item.description)
        ).appendTo('#tblAppointments');
	});
	console.log(appointments);
}

function displayFailure(xhr, status, exception) {
	console.log(xhr, status, exception);
}