with Ada.Text_IO; use Ada.Text_IO;
with ada.Integer_Text_IO; use Ada.Integer_Text_IO;
with ada.strings.unbounded; use ada.strings.unbounded;
with ada.strings.unbounded.Text_IO; use ada.strings.unbounded.Text_IO;
with Ada.Numerics.Elementary_Functions; use Ada.Numerics.Elementary_Functions;
with ada.directories; use ada.directories;

procedure calce is
    outfp : file_type;
    filename : unbounded_string;
    value : unbounded_string;
    --ans : character;
    n, carry, temp : integer;
    m, test : float;

    procedure getFilename is
    begin
    loop
        -- prompt the user for a filename for the output
        put_line("Enter the filename you wish to store the value of e: "); -- prompt user for input file
        get_line(filename);
        
        -- check if the file exists
        if exists(to_string(filename)) then
            put_line("File exists and it will be overwritten. ");
            exit;
        else
            put_line("File does not exist - will be created. ");
            exit;
        end if;
    end loop;
    end getFilename;

    procedure keepe is
    begin
    put_line("Enter the number of significant digits to calculate: ");
    get_line(value);
    n := integer'value(to_string(value));

    -- prompt the user for the filename
    getFilename;

    m := 4.0;
    test := (float(n)+1.0)*2.30258509;

    loop
        if m*(log(m)-1.0) + 0.5*log(6.2831852*m) < test then
            m := m + 1.0;
        else 
            exit;
        end if;
    end loop;

    declare
    d : array(1..n) of integer;
    coef : array(1..integer(m+1.0)) of integer;

    -- initialize digits
    begin
    for j in 1..integer(m+1.0) loop
        if j = 1 then 
            coef(j) := 0;
        else 
            coef(j) := 1;
        end if;
    end loop;
    d(1) := 2;

    carry := 0;
    -- calculate n-1 significant digits in e (the first digit was initialized above)
    for x in 2..n loop
        carry := 0;
        for y in reverse 2..integer(m) loop
            temp := coef(y) * 10 + carry;
            carry := temp / y;
            coef(y) := temp - carry * y;
        end loop;
        d(x) := carry;
    end loop;

    -- write the calculated digits of e to the file specified by the user
    put_line("Writing to file...");
    create(outfp, out_file, to_string(filename));
    set_output(outfp);
    for z in 1..n loop
        put(d(z), width=>1);
        if n > 1 and z = 1 then
            -- insert a decimal point for comparison test purposes
            put(outfp, ".");
        end if;
    end loop;
    set_output(standard_output);
    close(outfp);
    end;
    end keepe;

    begin
    put_line("CALCULATE e TO MANY DIGITS! ");
    keepe;
    put_line("Program finished! ");
end calce;
