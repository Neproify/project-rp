var groups = [];

function updateGroups()
{
	$('#groups tbody').html('');
	for (var i = 0; i < groups.length; i++) {
		var output = '<tr id="'+groups[i]['UID']+'">';
		output += '<td>'+groups[i]['UID']+'</td>';
		output += '<td id="">'+groups[i]['name']+'</td>';
		output += '<td id="groupPanel">Panel grupy</td>';
		output += '</tr>';
		var group = $(output);
		group.appendTo('#groups tbody');
		group.on('click', function(event)
		{
			var parent = $(event.target).parent();
			if(event.target.id == "groupPanel")
			{
				openGroupPanel(parent.attr('id'));
			}
		});
	};
}

function addGroup(UID, name)
{
	groups.push({UID: UID, name: name});
}

function clearGroups()
{
	groups = [];
}

function openGroupPanel(UID)
{
	mta.triggerEvent('openGroupPanel', UID);
}