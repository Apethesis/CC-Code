function prite(x,y,text,tcolor,bcolor)
    if tcolor == nil then
        tcolor = colors.white
    end
    if bcolor == nil then
        bcolor = colors.black
    end
    term.setCursorPos(x,y)
    term.setTextColor(tcolor)
    term.setBackgroundColor(bcolor)
    term.write(text)
end -- this is prite