trigger Task on Task (before insert, after insert, before update, after update, before delete) {
    new TaskTriggerHandler().run();
}