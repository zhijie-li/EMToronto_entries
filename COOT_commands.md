# A list of useful python functions
'''
set_nomenclature_errors_on_read ("autocorrect")
set_nomenclature_errors_on_read ("ignore")

set_refine_auto_range_step (2)
refine_residue_sphere_radius = 1.5
set_show_unit_cells_all (0)



def del_chains(imol,chains):
    if isinstance(chains,basestring):
        chains=list(chains)
    for c in chains:
        delete_chain(imol,c)
def sel(chain,res):
    return [[chain,i,''] for i in res]
    

def sel_range(chain,start,stop):
    return [[chain,i,''] for i in range(start,stop+1)]


handle_read_draw_molecule_with_recentre ("A.pdb", 1)
del_chains(0,'ABCDEF')
s1=sel_range('B',20,337)
s=[['B',5081,'']]+s1
refine_residues(0,s)

copy_residue_range(5,'L',12,'A',105,214)

delete_residue_range(0,'A',1,2000)
'''

# Transforming maps and coordinates in COOT
To get the transformation matrix:
```
d:\CCP4\6.4\bin\superpose.exe pdbb.pdb pdba.pdb >out1.log
        Rx         Ry         Rz           T
     -0.234     -0.944      0.231       15.850
     -0.484     -0.093     -0.870       52.586
      0.843     -0.316     -0.435        8.455
```

From COOT SSM:
```
pdbb.pdb to pdba.pdb
-0.2342,-0.9443,0.2314
-0.4838, -0.09325,-0.8702
0.8432,-0.3157, -0.435
(15.8497,52.5858,8.45504)
```

# To transform map in P1
guile command:
```
(transform-map imol mat trans about-pt radius space-group cell)
//transform a block of map with radius 10, at current view point, the cell(1) means take the cell parameter of molecule 1, it is madatory, due to program bug
transform_map (4, (-0.2342,-0.9443,0.2314,-0.4838, -0.09325,-0.8702,0.8432,-0.3157, -0.435),(15.85,52.59,8.455), rotation_centre(),10,"P 1",cell(1))
//transform a block of map with radius 35, at center of molecule 2
transform_map (4, (-0.2342,-0.9443,0.2314,-0.4838, -0.09325,-0.8702,0.8432,-0.3157, -0.435),(15.85,52.59,8.455), center_of_mass(2),35,"P 1",cell(1))
```
To transform PDB only
```
transform_molecule_by(2, -0.2342,-0.9443,0.2314,-0.4838, -0.09325,-0.8702,0.8432,-0.3157, -0.435,15.85,52.59,8.455 )
```

## COOT python scripting examples
getting the internal atom index
```
atom_index_full(0,"A", 37, "", "O", "") 

'''
<c-interface.cc>
// return -1 if atom not found.
int atom_index_full(int imol, const char *chain_id, int iresno, const char *inscode, const char *atom_id, const char *altconf) {
'''
```
fix an atom:
```
mark_atom_as_fixed(0,['A',37,'',' C  ',''],1)
```

COOT C++ source for reference:
```
#ifdef USE_PYTHON
PyObject *mark_atom_as_fixed_py(int imol, PyObject *atom_spec, int state) {
   PyObject *retval = Py_False;
   std::pair<bool, coot::atom_spec_t> p = make_atom_spec_py(atom_spec);
   if (p.first) {
      graphics_info_t::mark_atom_as_fixed(imol, p.second, state);
      graphics_draw();
      retval = Py_True; // Shall we return True if atom got marked?
   }
   Py_INCREF(retval);
   return retval;
}
#endif // USE_PYTHON 

enum fixed_atom_pick_state_t { FIXED_ATOM_NO_PICK = 0, 
				  FIXED_ATOM_FIX = 1, 
				  FIXED_ATOM_UNFIX = 2 };
				  
				  

// ipick is on/off, is_unpick is when we are picking a fixed atom to
// be unfixed.
// 
void setup_fixed_atom_pick(short int ipick, short int is_unpick) {

   graphics_info_t g;
   if (ipick == 0) {
      graphics_info_t::in_fixed_atom_define = coot::FIXED_ATOM_NO_PICK;
   } else {
      g.pick_cursor_maybe();
      if (is_unpick) {
	 graphics_info_t::in_fixed_atom_define = coot::FIXED_ATOM_UNFIX;
      } else { 
	 graphics_info_t::in_fixed_atom_define = coot::FIXED_ATOM_FIX;
      }
   }
}
void
graphics_info_t::check_if_in_fixed_atom_define(GdkEventButton *event,
					       const GdkModifierType &state) {

   
   if (in_fixed_atom_define != coot::FIXED_ATOM_NO_PICK) {
      // we were listening for a pick then...
      bool pick_state = 0;
      if (in_fixed_atom_define == coot::FIXED_ATOM_FIX) {
	 pick_state = 1;
      }
      if (in_fixed_atom_define == coot::FIXED_ATOM_UNFIX) {
	 pick_state = 0;
      }

      // pick and fix are interchanged here. I mean on
      // UNFIX/pick_state=0 that an atom that is marked as FIXED (it
      // should have a dot) becomes unmarked as fixed.
      // 
      pick_info naii = atom_pick(event);
      if (naii.success == GL_TRUE) {
	 coot::atom_spec_t as(molecules[naii.imol].atom_sel.atom_selection[naii.atom_index]);
	 mark_atom_as_fixed(naii.imol, as, pick_state);
	 std::cout << "   " << as << " is a marked as fixed " << pick_state << std::endl;
	 graphics_draw();

	 // Sadly, Ctrl + left mouse click is intercepted upstream of
	 // this and we don't get to see it here.  Currently (20080212).
	 
	 if (! (state & GDK_CONTROL_MASK)) { 
	    // Ctrl key is not pressed.
	    if (!fixed_atom_dialog) {
	       std::cout << "Ooops fixed atom dialog has gone!" << std::endl;
	    } else { 
	       GtkWidget *button1 = lookup_widget(fixed_atom_dialog,   "fix_atom_togglebutton");
	       GtkWidget *button2 = lookup_widget(fixed_atom_dialog, "unfix_atom_togglebutton");
	       if (button1)
		  gtk_toggle_button_set_active(GTK_TOGGLE_BUTTON(button1), FALSE);
	       if (button2)
		  gtk_toggle_button_set_active(GTK_TOGGLE_BUTTON(button2), FALSE);
	       in_fixed_atom_define = coot::FIXED_ATOM_NO_PICK;
	       normal_cursor();
	    }
	 }
      }
   }
}
```

##Fix the whole backbone
```
imol=0
chain='A'

resrange=range(1500)

for res in resrange:
  for atm in ('CA','N','O','C'):
    atm_formated=' {:3}'.format(atm)
    imol=0
    s=[chain,res,'',atm_formated,'']
    print(s)
    
    mark_atom_as_fixed(imol,s,1) #1 means fix, 0 means unfix
```

# atom_spec syntax (python)
Note the very specific format for atom names. One leading space, four chars in total (wwPDB specifies cols 13-16, COOT always starts at col 14).
```
[str chain, int res_no, str ins_code, str atm, str alt_conf]

["A", 81, "", " CA ", ""]
```

## Source: <c-interface-build.cc>
```
#ifdef USE_GUILE
// e.g. atom_spec: '("A" 81 "" " CA " "")
//      position   '(2.3 3.4 5.6)


#ifdef USE_PYTHON
PyObject *drag_intermediate_atom_py(PyObject *atom_spec, PyObject *position) {
// e.g. atom_spec: ["A", 81, "", " CA ", ""]
//      position   [2.3, 3.4, 5.6]

   PyObject *retval = Py_False;
   PyObject *x_py;
   PyObject *y_py;
   PyObject *z_py;
   std::pair<bool, coot::atom_spec_t> p = make_atom_spec_py(atom_spec);
   if (p.first) {
      int pos_length = PyObject_Length(position);
      if (pos_length == 3) {
	 x_py = PyList_GetItem(position, 0);
	 y_py = PyList_GetItem(position, 1);
	 z_py = PyList_GetItem(position, 2);
	 double x = PyFloat_AsDouble(x_py);
	 double y = PyFloat_AsDouble(y_py);
	 double z = PyFloat_AsDouble(z_py);
	 clipper::Coord_orth pt(x,y,z);
	 graphics_info_t::drag_intermediate_atom(p.second, pt);
	 retval = Py_True; // Shall we return True if atom is dragged?
      }
   }

   Py_INCREF(retval);
   return retval;
}
#endif // USE_PYTHON
```


## Source: <graphics-info.cc>
```
#ifdef USE_PYTHON
// lets have it as a tuple not a list
PyObject *
graphics_info_t::atom_spec_to_py(const coot::atom_spec_t &spec) const {

  //  PyObject *r = PyTuple_New(6);
  PyObject *r = PyList_New(6);
  PyList_SetItem(r, 0, PyInt_FromLong(spec.int_user_data));
  PyList_SetItem(r, 1, PyString_FromString(spec.chain_id.c_str()));
  PyList_SetItem(r, 2, PyInt_FromLong(spec.res_no));
  PyList_SetItem(r, 3, PyString_FromString(spec.ins_code.c_str()));
  PyList_SetItem(r, 4, PyString_FromString(spec.atom_name.c_str()));
  PyList_SetItem(r, 5, PyString_FromString(spec.alt_conf.c_str()));

  return r;
} 
#endif
```
