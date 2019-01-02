var items = [];

function updateItems()
{
	$('#items tbody').html('');
	for(var i = 0; i < items.length; i++)
	{
		var output = '<tr id="'+items[i]['UID']+'">';
		output += '<td>'+items[i]['UID']+'</td>';
		output += '<td id="useItem">'+items[i]['name']+'</td>';
		output += '<td id="dropItem">Wyrzuć</td>';
		output += '</tr>';
		var item = $(output);
		item.appendTo('#items tbody');
		if(items[i]['used'] == true)
		{
			item.css('font-weight', '900');
		}
		item.on('click', function(event)
		{
			var parent = $(event.target).parent();
			if(event.target.id == "useItem")
			{
				useItem(parent.attr('id'));
			}
			if(event.target.id == "dropItem")
			{
				dropItem(parent.attr('id'));
			}
		});
	}
}

function clearItems()
{
	items = [];
}

function addItem(UID, name, used)
{
	items.push({UID: UID, name: name, used: used});
}

function showItems()
{
	updateItems();
}

function useItem(UID)
{
	mta.triggerEvent('usePlayerItem', UID);
}

function dropItem(UID)
{
	mta.triggerEvent('dropPlayerItem', UID);
}