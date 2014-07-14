#It's a little worrying that .bucket-dropdown hides when .navbar-collapse shows
#This is what's required, but no javascript or html actually tells it to do this.
#It seems to be some happy-accident side effect

navbar_collapse_shown = false

$.ajax(url: "/mock/bucket_items").done (json) ->
    $.each json, (index, bucket_item) ->
        bucket_item_panel = """
            <li class='panel panel-info'>
                <div class='panel-heading'
                     data-toggle='collapse'
                     data-parent='#accordion'
                     data-target='#collapse#{index}'>
                    <h4 class='panel-title'>
                        #{bucket_item['type']}: #{bucket_item['description']}
                    </h4>
                </div>
                <div id='collapse#{index}' class='panel-collapse collapse'>
                    <div class='panel-body'>
                        <input type='text' value='#{bucket_item['description']}'><br>
                        <textarea>#{bucket_item['notes']}</textarea>
                        <button type='button' class='btn btn-default'>
                            Save
                        </button>
                        <button type='button' class='btn btn-default'>
                            Cancel
                        </button>
                        <button type='button' class='btn btn-default'>
                            Done
                    </div>
                </div>
            </li>
        """
        $('#sortable-bucket-item-list').append bucket_item_panel

#TODO what about ajax failure?
populate_bucket_dropdown = (selected_bucket) ->
    $.ajax(url: "/mock/buckets").done (json) ->
        $("#bucket-dropdown-head-text").empty().append selected_bucket
        json.splice json.indexOf(selected_bucket), 1
        $("#bucket-dropdown-list").empty()
        $.each json, (index, bucket) ->
            $("#bucket-dropdown-list").append "<li><a href='#'>#{bucket}</a></li>"

#TODO why can't I do .click?
$(document).on 'click', '#bucket-dropdown-list li a', (e) ->
    e.preventDefault()
    populate_bucket_dropdown $(this).parent().text()

#TODO initial dropdown population shouldn't be an ajax call
#TODO nor should it be tied to a hard-coded bucket name
populate_bucket_dropdown('New Stuff')

#TODO why can't I do $('.bucket-dropdown').on 'show.bs.dropdown' ?
$(document).on 'show.bs.dropdown', '.bucket-dropdown',  ->
    if navbar_collapse_shown
        $('.navbar-collapse').collapse 'hide'
        navbar_collapse_shown = false
    $('.bucket-dropdown').dropdown

$(document).on 'show.bs.collapse', '.navbar-collapse', -> navbar_collapse_shown = true

#TODO Why does this have to be inside a function?
$ ->
    $("#sortable-bucket-item-list").sortable
    $("#sortable-bucket-item-list").sortable { cursor: "move" }
