$(function () {
    var Event = Backbone.Model.extend();

    var Events = Backbone.Collection.extend({
        model:Event,
        url:'/events'
    });

    var EventsView = Backbone.View.extend({
        initialize:function () {
            _.bindAll(this);

            this.collection.bind('reset', this.addAll);
            this.collection.bind('add', this.addOne);
            this.collection.bind('change', this.change);
            this.collection.bind('destroy', this.destroy);

            this.eventView = new EventView();
        },
        render:function () {
            this.el.fullCalendar({
                header:{
                    left:'prev,next today',
                    center:'title',
                    right:'month,agendaWeek,agendaDay'
                },
                selectable:true,
                selectHelper:true,
                editable:true,
                ignoreTimezone:false,
                select:this.select,
                eventClick:this.eventClick,
                eventRender:this.eventRender,
                eventDrop:this.eventDropOrResize,
                eventResize:this.eventDropOrResize
            });
        },
        addAll:function () {
            this.el.fullCalendar('addEventSource', this.collection.toJSON());
        },
        addOne:function (event) {
            this.el.fullCalendar('renderEvent', event.toJSON());
        },
        select:function (startDate, endDate) {
            this.eventView.collection = this.collection;
            this.eventView.model = new Event({start:startDate, end:endDate});
            this.eventView.render();
        },
        eventClick:function (fcEvent) {
            this.eventView.model = this.collection.get(fcEvent.id);
            this.eventView.render();
        },
        eventRender:function (event, element) {
            if (event.importance < 0.33) {
                element.addClass('fc-zero');
            }

            else if (event.importance < 0.66) {
                element.addClass('fc-plus');
                element.css("border-color", event.color);
                element.css("color", event.color);
                element.css("background-color", "transparent");
            }
            else {
                element.addClass('fc-plusplus');
            }
            var time = event.start.format("longTime");
            element.qtip({
                hide:{
                    when:'mouseout mousedown mouseup'
                },
                show:{
                    delay:1,
                    effect:{ length:10 },
                    when:'mouseover'
                },
                content:{
                    text:event.title + " at " + time
                },
                style:{
                    padding:5,
                    background:'#424242',
                    color:'white',
                    textAlign:'center',
                    border:{
                        width:7,
                        radius:5,
                        color:'#424242'
                    }
                },
                position:{
                    adjust:{ screen:true }
                }
            });
        },
        change:function (event) {
            // Look up the underlying event in the calendar and update its details from the model
            var fcEvent = this.el.fullCalendar('clientEvents', event.get('id'))[0];
            fcEvent.title = event.get('title');
            fcEvent.color = event.get('color');
            fcEvent.allDay = event.get('allDay');
            fcEvent.start = event.get('start');
            fcEvent.end = event.get('end');
            fcEvent.importance = event.get('importance');
            fcEvent.autoImportance = event.get('autoImportance');
            this.el.fullCalendar('updateEvent', fcEvent);
        },
        eventDropOrResize:function (fcEvent) {
            // Lookup the model that has the ID of the event and update its attributes
            this.collection.get(fcEvent.id).save({start:fcEvent.start, end:fcEvent.end});
        },
        destroy:function (event) {
            this.el.fullCalendar('removeEvents', event.id);
        }
    });

    var EventView = Backbone.View.extend({
        el:$('#eventDialog'),
        initialize:function () {
            _.bindAll(this);
        },
        render:function () {
            var buttons = {'Ok':this.save};
            if (!this.model.isNew()) {
                _.extend(buttons, {'Delete':this.destroy});
            }
            _.extend(buttons, {'Cancel':this.close});

            this.el.dialog({
                modal:true,
                title:(this.model.isNew() ? 'New' : 'Edit') + ' Event',
                buttons:buttons,
                open:this.open
            });

            return this;
        },
        open:function () {
            this.$('#title').val(this.model.get('title'));
            this.$('#color').val(this.model.get('color'));
            if (this.model.get('color') == "#000000") {
                this.$('#color').val('#' + Math.floor(Math.random() * 16777215).toString(16));
            }
            this.$('#allDay').prop('checked', this.model.get('allDay'));
            this.$('#importance').val(parseFloat(this.model.get('importance')));
            this.$('#autoImportance').prop('checked', this.model.get('autoImportance'));
            this.$('#start').val(new Date(this.model.get('start')).format("mm/dd/yyyy HH:MM"));
            this.$('#end').val(new Date(this.model.get('end')).format("mm/dd/yyyy HH:MM"));
        },
        save:function () {
            this.model.set({
                'title':this.$('#title').val(),
                'color':this.$('#color').val(),
                'allDay':this.$('#allDay').prop('checked'),
                'importance':this.$('#importance').val(),
                'start':new Date(this.$('#start').val()).toUTCString(),
                'end':new Date(this.$('#end').val()).toUTCString(),
                'autoImportance':this.$('#autoImportance').prop('checked'),
                'user_id':this.$('#user_id').val()
            });
            if (this.model.isNew()) {
                this.collection.create(this.model, {success:this.close});
            } else {
                this.model.save({}, {success:this.close});
            }
        },
        close:function () {
            this.el.dialog('close');
        },
        destroy:function () {
            this.model.destroy({success:this.close});
        }
    });

    var events = new Events();
    new EventsView({el:$("#calendar"), collection:events}).render();
    events.fetch();

    $('#start').datetimepicker();
    $('#end').datetimepicker();
});