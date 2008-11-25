$$('#agency .create.action').first().observe('click', function(evt) {
    console.log('user chose to create an agency');
    hideSelectAgencyForm();
    showCreateAgencyForm();
});

$$('#agency .select.action').first().observe('click', function(evt) {
    console.log('user chose to select an agency');
    hideCreateAgencyForm();
    showSelectAgencyForm();
});

function hideCreateAgencyForm() {
    $$('#agency .create-input').each(function(input) {
        input.disable();
    });
    $('create').hide();
    $$('#agency .create.action').first().show();
}

function showCreateAgencyForm() {
    $$('#agency .create-input').each(function(input) {
        input.enable();
    });
    $('create').show();
    $$('#agency .create.action').first().hide();
}

function hideSelectAgencyForm() {
    $('user_agency_id').disable();
    $('select').hide();
    $$('#agency .select.action').first().show();
}

function showSelectAgencyForm() {
    $('user_agency_id').enable();
    $('select').show();
    $$('#agency .select.action').first().hide();
}