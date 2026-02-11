// handle two column layout on 1000px breakpoint
const handleColumns = () => {

    // main element is the flex container for the columns
    const $MAIN = document.querySelector('main');

    // verify breakpoint width
    if (document.querySelector('html').clientWidth >= 1000) {

        // shrink main height to force column wrapping
        $MAIN.style.height = 'auto';
        let columnsHeight = parseInt($MAIN.getBoundingClientRect().height * (3/5));
        $MAIN.style.height = `${columnsHeight}px`;

        // correct gap between bottom of lowest section in main and bottom of page
        // find the lowest section
        const mainContentArray = Array.from(document.querySelectorAll('main > *'));
        mainContentArray.sort((a, b) => {return b.getBoundingClientRect().bottom - a.getBoundingClientRect().bottom});
        const lowestElement = mainContentArray[0];
        // find difference between bottom of lowest section and bottom of main
        const bottomGap = parseInt($MAIN.getBoundingClientRect().bottom - lowestElement.getBoundingClientRect().bottom);
        console.log(bottomGap);
        columnsHeight -= bottomGap;
        $MAIN.style.height = `${columnsHeight}px`;        
        
        // calculate width of body - left and right padding
        const $BODY = document.querySelector('body');
        const getBodyWidth = () => {
            const BODY_STYLES = getComputedStyle($BODY);
            let bodyWidth = $BODY.clientWidth;
            bodyWidth -= parseFloat(BODY_STYLES.paddingLeft) + parseFloat(BODY_STYLES.paddingRight);
            return bodyWidth;
        }

        // multiply width of main by 2 and add 1em for the flex gap
        const calcColumnsWidth = () => {
            const MAIN_STYLES = getComputedStyle($MAIN);
            const mainWidth = $MAIN.clientWidth;
            const columnsWidth = (mainWidth * 2) + parseFloat(MAIN_STYLES.gap);
            return columnsWidth;
        }

        // set main left margin to half of bodyWidth - columnsWidth
        const mainLeftMargin = (getBodyWidth() - calcColumnsWidth()) / 2;
        $MAIN.style.marginLeft = `${mainLeftMargin}px`;

    } else {
        $MAIN.style.height = 'auto';
        $MAIN.style.marginLeft = 'auto';
    }
}

window.addEventListener('DOMContentLoaded', handleColumns);
window.addEventListener('resize', handleColumns);