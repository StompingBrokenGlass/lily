/* Contents autogenerated by dyna_tools.py */
const char *lily_sys_dynaload_table[] = {
    "\0\0"
    ,"R\0argv\0List[String]"
    ,"Z"
};

void *lily_sys_loader(lily_options *o, uint16_t *c, int id)
{
    switch (id) {
        case 1: return load_var_argv(o, c);
        default: return NULL;
    }
}

#define register_sys(p) lily_register_package(parser, "sys", lily_sys_dynaload_table, lily_sys_loader);
