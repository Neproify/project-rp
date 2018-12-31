var items = [];

function updateItems()
{
	$('#items tbody').html('');
	for(var i = 0; i < items.length; i++)
	{
		var output = '<tr>';
		output += '<td>'+items[i]['UID']+'</td>';
		output += '<td id="useItem-'+items[i]['UID']+'">'+items[i]['name']+'</td>';
		output += '<td><div class="ui dropdown"><div class="default text">Opcje</div>';
		output += '<div class="menu"><div class="item" id="dropItem-'+items[i]['UID']+'">Wyrzuć</div></div>';
		output += '</div></td>';
		output += '</tr>';
		var item = $(output);
		item.appendTo('#items tbody');
		$('.ui.dropdown').dropdown();
		if(items[i]['used'] == true)
		{
			item.css('font-weight', '900');
		}
		item.on('click', function(event)
		{
			if(event.target.id.includes('useItem'))
			{
				useItem(event.target.id.substring(8));
			}
			if(event.target.id.includes('dropItem'))
			{
				dropItem(event.target.id.substring(9));
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