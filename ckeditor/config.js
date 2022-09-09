CKEDITOR.editorConfig = function( config ) {
    config.extraPlugins = 'fixed';
	config.toolbarGroups = [
		{ name: 'document', groups: [ 'mode', 'document', 'doctools' ] },
		{ name: 'clipboard', groups: [ 'clipboard', 'undo' ] },
		{ name: 'editing', groups: [ 'find', 'selection', 'spellchecker', 'editing' ] },
		{ name: 'forms', groups: [ 'forms' ] },
		'/',
		{ name: 'basicstyles', groups: [ 'basicstyles', 'cleanup' ] },
		{ name: 'paragraph', groups: [ 'list', 'indent', 'blocks', 'align', 'bidi', 'paragraph' ] },
		{ name: 'links', groups: [ 'links' ] },
		{ name: 'insert', groups: [ 'insert' ] },
		{ name: 'colors', groups: [ 'colors' ] },
		'/',
		{ name: 'styles', groups: [ 'styles' ] },
		{ name: 'tools', groups: [ 'tools' ] },
		{ name: 'others', groups: [ 'others' ] },
		{ name: 'about', groups: [ 'about' ] }
	];

	config.removeButtons = 'SpecialChar,PageBreak,Iframe,HorizontalRule,Table,Flash,Image,Link,Unlink,Anchor,About,Maximize,Styles,Format,Font,FontSize,BidiLtr,BidiRtl,Language,Blockquote,CreateDiv,NumberedList,BulletedList,Outdent,Indent,CopyFormatting,RemoveFormat,Form,Checkbox,Radio,TextField,Textarea,Select,Button,ImageButton,HiddenField,Scayt,SelectAll,Find,Replace,Undo,Redo,Cut,Copy,Source,Save,Templates,NewPage,Preview,Print,Paste,PasteText,PasteFromWord,ShowBlocks,Strike,Subscript,Superscript';

	config.smiley_path = 'http://dev1.thesquadtours.com/Scripts/ckeditor/plugins/smiley/images/';

    CKEDITOR.config.smiley_images = [
    	'regular_smile.gif', 'sad_smile.gif', 'wink_smile.gif', 'teeth_smile.gif', 'confused_smile.gif', 'tongue_smile.gif',
    	'embarrassed_smile.gif', 'omg_smile.gif', 'whatchutalkingabout_smile.gif', 'angry_smile.gif', 'angel_smile.gif', 'shades_smile.gif',
    	'devil_smile.gif', 'cry_smile.gif', 'lightbulb.gif', 'thumbs_down.gif', 'thumbs_up.gif', 'heart.gif',
    	'broken_heart.gif', 'kiss.gif', 'envelope.gif'
    ];
CKEDITOR.config.smiley_descriptions = [
	'smiley', 'sad', 'wink', 'laugh', 'frown', 'cheeky', 'blush', 'surprise',
	'indecision', 'angry', 'angel', 'cool', 'devil', 'crying', 'enlightened', 'no',
	'yes', 'heart', 'broken heart', 'kiss', 'mail'
];
};
