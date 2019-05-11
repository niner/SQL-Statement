use SQL::Statement::SelectList;

unit class SQL::Statement::Asterisk does SQL::Statement::SelectList;

method sql() {
    '*'
}
