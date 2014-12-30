$(document).ready( ->
  editorElement = document.getElementById('json-editor')

  if editorElement
    resetTooltips = ->
      schema = JSON.parse(document.getElementById('schema-'+currentStorageName).innerText)
      for key, value of schema
        parts = key.split(':')
        primaryKey = parts[0]
        secondaryKey = parts[1]
        if secondaryKey == 'description'
          $('#json-editor .field').each( ->
            if @.innerText == primaryKey
              valueElem = $(@).parent().parent().find('.value')[0]
              valueElem.title = value
              $(valueElem).tooltip({
                position: { my: "left+10 top+5", at: "right top-5", collision: "flipfit" }
              })
          )

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

    $(document).on('focus', '[contenteditable]', (event) ->
      if $(@).tooltip('instance')
        $(@).tooltip('close')
    )

    $(document).on('keyup', '[contenteditable]', (event) ->
      if event.which == 13
        $(this).trigger('blur')
    )

    $(document).on('blur', '[contenteditable]', (event) ->
      setTimeout(( -> resetTooltips()), 250)
    )

    storages = {}
    $('.json-data').each( ->
      if @.id.indexOf('storage-') == 0
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
      resetTooltips() 
    )
    $('.storage-list-item').first().click();

)