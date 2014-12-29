$(document).ready( ->
  $('.device-name').on('blur', ->
    $metadata = $('#metadata')
    $.ajax(
      url: '/devices/' + $metadata.data('device-id'),
      type: 'PATCH',
      data:
        device:
          display_name: @.innerText
    )
  )

  $(document).on('keyup', '[contenteditable]', (event) ->
    if event.which == 13
      $(this).trigger('blur')
  )

  storages = {}
  $('.json-data').each( ->
    storages[@.id.replace('storage-', '')] = JSON.parse(@.innerHTML)
  )
  currentStorageName = ''

  setInterval(( ->
    $('table.tree > tbody > tr').each( ->
      children = $(@).children()
      size = children.size()
      if size >= 3
        children[0].remove();
        children[1].remove();
    )
  ), 50)

  editor = new JSONEditor(document.getElementById('json-editor'),
    'mode': 'form',
    'change': ->
      storages[currentStorageName] = editor.get()
      storagesData = [] 
      for name, data of storages
        storagesData.push(
          name: name
          data: data
        )
      $metadata = $('#metadata')
      $.ajax(
        url: '/api/update_storages'
        type: 'POST'
        data:
          app_name: $metadata.data('app-name')
          device_uuid: $metadata.data('device-uuid')
          storages_data: JSON.stringify(storagesData)
      )
  )

  $('.storage-list-item').on('click', (e) ->
    $('.storage-list-item').removeClass('active')
    $(@).addClass('active')
    currentStorageName = $(@).data('storage-name')
    editor.set(storages[currentStorageName])
    editor.setName(@.innerText)
  )
  $('.storage-list-item').first().click();
)