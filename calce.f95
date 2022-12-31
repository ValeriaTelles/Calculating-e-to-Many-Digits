program calce

    implicit none

    real :: m
    integer :: n
    integer :: unitWrite

    write(*,*) "CALCULATE e TO MANY DIGITS! "
    write(*,*) "Enter the number of significant digits to calculate: "
    read(*,*) n
    
    call checkm(n, m)

    call keepe(n, m, unitWrite)
    write(*,*) "Writing to file..."

    write(*,*) "Program finished! "
    
end program calce

subroutine checkm(n, m)

    implicit none

    integer, intent(in) :: n
    real, intent(out) :: m
    real :: test
    
    m = 4
    test = (n+1)*2.30258509

    do while (m*(log(m)-1.0) + 0.5*log(6.2831852*m) < test)
        m = m + 1
    end do

    return

end subroutine checkm

subroutine keepe(n, m, unitWrite)

    implicit none

    integer, intent(in) :: n
    real, intent(in) :: m
    character(len=30) :: fname
    integer, intent(in) :: unitWrite
    integer :: i, j, k, x
    integer :: carry, temp
    integer, dimension(n) :: d
    integer, dimension(int(m)+1) :: coef
    logical :: lexist

    ! initialize digits
    do i = 1,(int(m)+1)
        if (i == 1) then 
            coef(i) = 0
        else
            coef(i) = 1
        end if
    end do
    d(1) = 2

    carry = 0
    ! calculate n-1 significant digits in e (the first digit was initialized above)
    do j = 2,n
        carry = 0
        do k = int(m),2,-1
            temp = coef(k) * 10 + carry
            carry = temp / k
            coef(k) = temp - carry * k
        end do
        d(j) = carry
    end do

    ! prompt the user for a filename for the output
    write (*,*) "Enter the filename you wish to store the value of e: "
    read (*, "(A)") fname

    ! check if the file exists
    inquire (file=fname, exist=lexist)
    if (lexist) then
        write(*,*) "File exists and it will be overwritten. "
        ! write the calculated digits of e to the file specified by the user
        open (unit=unitWrite, file=fname, status='replace', action='write')
    else
        write(*,*) "File does not exist - will be created. "
        ! write the calculated digits of e to the file specified by the user
        open (unit=unitWrite, file=fname, status='new', action='write')
    end if

    do x = 1, n
        write (unitWrite, '(i0)', advance='no') d(x)
        if (n > 1) then
            if (x == 1) then
                write (unitWrite, '(A)', advance='no') "." 
            end if
        end if
    end do
    ! adding a newline character to the end to match the testfile
    write (unitWrite, '(A)') "" 

    return 

end subroutine keepe