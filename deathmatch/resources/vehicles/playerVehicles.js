var vehicles = [];

function updateVehicles()
{
	$('#vehicles tbody').html('');
	for(var i = 0; i < vehicles.length; i++)
	{
		var output = '<tr id="'+vehicles[i]['UID']+'">';
		output += '<td>'+vehicles[i]['UID']+'</td>';
		output += '<td>'+vehicles[i]['name']+'</td>';
		output += '<td><cos id="spawnVehicle">(Un)Spawn</cos>  <cos id="findVehicle">Namierz</cos></td>';
		output += '</tr>';
		var vehicle = $(output);
		vehicle.appendTo('#vehicles tbody');

		vehicle.on('click', function(event)
		{
			var parent = $(event.target).parent();
			if(event.target.id == "spawnVehicle")
			{
				spawnVehicle(parent.parent().attr('id'));
			}
			if(event.target.id == "findVehicle")
			{
				findVehicle(parent.parent().attr('id'));
			}
		});
	}
}

function addVehicle(UID, name)
{
	vehicles.push({UID: UID, name: name});
}

function clearVehicles()
{
	vehicles = [];
}

function spawnVehicle(UID)
{
	mta.triggerEvent('spawnPlayerVehicle', UID);
}

function findVehicle(UID)
{
	mta.triggerEvent('findVehicle', UID);
}